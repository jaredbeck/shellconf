#!/usr/bin/env ruby
# frozen_string_literal: true

def main base, first, last, suffix, new_base
  first.upto(last) do |i|
    url = "#{base}#{i}#{suffix}"
    if exists?(url)
      puts "curl #{url} > #{new_base}#{i}#{suffix}"
      system "curl #{url} > #{new_base}#{i}#{suffix}"
      sleep (rand * 3).round
    end
  end
end

def exists? url
  w = "--write-out '%{http_code}'"
  o = "--output /dev/null"
  status_code = %x[curl --head #{w} #{o} #{url} 2> /dev/null]
  puts "#{status_code} #{url}"
  return status_code.to_i == 200
end

raise ArgumentError, 'Expected 5 arguments' unless ARGV.length == 5
main ARGV[0], ARGV[1], ARGV[2], ARGV[3], ARGV[4]
