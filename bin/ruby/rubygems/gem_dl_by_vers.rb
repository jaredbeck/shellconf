#!/usr/bin/env ruby

require "json"
require "net/http"
require "uri/https"

# Usage:
#
# gem_dl_by_vers.rb [gem_name]
#
# Writes download counts, one line per version, tab-delimited, to stdout.
#
class GemDlByVers
  def initialize(gem_name)
    fail "Invalid gem name: #{name}" unless valid_gem_name?(gem_name)
    @gem_name = gem_name
  end

  def run
    records.each do |record|
      puts format("%s\t%d", record["number"], record["downloads_count"])
    end
  end

  private

  def records
    JSON.parse(response)
  end

  def response
    Net::HTTP.get(uri)
  end

  def uri
    URI::HTTPS.build(
      host: "rubygems.org",
      path: "/api/v1/versions/#{@gem_name}.json"
    )
  end

  def valid_gem_name?(name)
    !name.match(/\A[a-z][a-z0-9_\-]+\Z/).nil?
  end
end

GemDlByVers.new(*ARGV).run
