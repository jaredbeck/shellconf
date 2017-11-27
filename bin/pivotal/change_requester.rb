#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'pp'
require 'net/http'

# Find stories in a given Tracker project with a given requester. For each
# story found, change the requester to someone new. Requires interaction
# with operator over STDIN (a prompt to continue).
class ChangeRequester
  HOST = "www.pivotaltracker.com"
  PORT = 443
  USAGE = <<-EOS
Usage: #{__FILE__} [api token] [project id] [initials before] [initials after]
Example: #{__FILE__} 3a72redacted578b 1510526 JOB KC
  EOS

  attr_reader :token

  def initialize(token, project_id, initials_before, initials_after)
    @token = token.to_s
    @project_id = project_id.to_i
    @initials_before = initials_before.to_s
    @initials_after = initials_after.to_s
  end

  def run
    Net::HTTP.start(HOST, port: PORT, use_ssl: true) do |con|
      stories = get_stories(con)
      people = get_people(con)
      requester_id_after = people.fetch(@initials_after)
      puts(
        format(
          "%d stories will be updated so that person id %d is the new requester.",
          stories.length,
          requester_id_after
        )
      )
      break unless prompt
      stories.each do |story|
        story_id = story.fetch("id").to_i
        update_story(story_id, requester_id_after, con)
      end
    end
  end

  private

  def assert_type(obj, klass)
    unless obj.is_a?(klass)
      fail TypeError, format("Expected %s, got %s", klass, obj.class)
    end
  end

  # Returns a hash mapping initials to "person ids"
  def get_people(http_con)
    path = "/services/v5/projects/#{@project_id}/memberships"
    uri = URI::HTTPS.build(host: HOST, path: path)
    request = Net::HTTP::Get.new uri
    request["X-TrackerToken"] = @token
    response = http_con.request(request)
    rsp_code = response.code.to_i
    if rsp_code == 200
      memberships = JSON.parse(response.body)
      assert_type memberships, Array
      memberships.each_with_object({}) { |project_membership, memo|
        person = project_membership.fetch("person")
        memo[person.fetch("initials").to_s] = person.fetch("id").to_i
      }
    else
      fail "Unexpected response code. Expected 200, got #{rsp_code}"
    end
  end

  def get_stories(http_con)
    path = "/services/v5/projects/#{@project_id}/stories"
    filter = "requester:#{@initials_before}"
    query = URI.encode_www_form(filter: filter)
    uri = URI::HTTPS.build(host: HOST, path: path, query: query)
    request = Net::HTTP::Get.new uri
    request["X-TrackerToken"] = @token
    response = http_con.request(request)
    rsp_code = response.code.to_i
    if rsp_code == 200
      stories = JSON.parse(response.body)
      assert_type stories, Array
      puts(
        format(
          "Found %d stories in project %d requested by %s",
          stories.length,
          @project_id,
          filter
        )
      )
      stories
    else
      fail "Unexpected response code. Expected 200, got #{rsp_code}"
    end
  end

  def prompt
    print "Continue? [Y/n]: "
    $stdin.gets.chomp == "Y"
  end

  def update_story(story_id, requester_id_after, http_con)
    path = "/services/v5/projects/#{@project_id}/stories/#{story_id}"
    uri = URI::HTTPS.build(host: HOST, path: path)
    req = Net::HTTP::Put.new(uri)
    req["Content-Type"] = "application/json"
    req["X-TrackerToken"] = @token
    data = { requested_by_id: requester_id_after }
    req.body = JSON.generate(data)
    rsp = http_con.request(req)
    rsp_code = rsp.code.to_i
    case rsp_code
    when 200
      puts(
        format(
          'Set requester of story id %d to "person id" %d',
          story_id,
          requester_id_after
        )
      )
    when 400
      warn format("Unable to set requester of story id %d", story_id)
      warn rsp.body
      warn format("Skipping story id %d", story_id)
    else
      fail "Unexpected response code: #{rsp_code}"
    end
  end
end

begin
  ChangeRequester.new(*ARGV).run
rescue ArgumentError => e
  warn ChangeRequester::USAGE
  warn e.message
end
