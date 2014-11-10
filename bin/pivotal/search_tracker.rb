#!/usr/bin/env ruby

require 'csv'
require 'json'
require 'pp'
require 'pry'
require 'net/http'

class SearchTracker
  HOST = 'www.pivotaltracker.com'

  attr_reader :token

  def initialize(token)
    @token = token
  end

  def csv(projects, stories)
    project_names = projects.inject({}) { |a,e| a.merge(e['project_id'] => e['project_name']) }
    CSV.generate do |csv|
      csv << ['project_name', 'name', 'deadline', 'current_state', 'created_at', 'url']
      stories.each do |s|
        csv << [
          project_names[s['project_id']],
          s['name'],
          s['deadline'],
          s['current_state'],
          s['created_at'],
          s['url']
        ]
      end
    end
  end

  def run
    projects = get_projects
    pids = projects.map { |p| p['project_id'] }
    stories = search(pids, query: 'type:Release')
    puts csv(projects, stories)
  end

  # returns an array of project ids
  # curl -X GET -H "X-TrackerToken: $TOKEN" "https://www.pivotaltracker.com/services/v5/me"
  def get_projects
    me = request('/services/v5/me')
    me['projects']
  end

  def request(path, query = nil)
    if query.is_a?(Hash)
      query = URI.encode_www_form(query)
    end
    uri = URI::HTTPS.build(host: HOST, path: path, query: query)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    # https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    headers = { 'Content-Type' => 'application/json', 'X-TrackerToken' => token }
    response = https.get(uri, headers)
    parsed = JSON.parse(response.body)
    if parsed.is_a?(Hash) && parsed['kind'] == 'error'
      $stderr.puts parsed.to_s
      raise RuntimeError
    end
    parsed
  end

  def search(project_ids, query = {})
    stories = []
    project_ids.each do |pid|
      response = request("/services/v5/projects/#{pid}/search", query)
      stories.concat response['stories']['stories']
    end
    stories
  end

end

SearchTracker.new(*ARGV).run
