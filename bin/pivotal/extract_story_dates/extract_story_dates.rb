# frozen_string_literal: true

# Given a csv file and a cutoff date, output the story id, latest
# date, and a boolean re: cutoff. - Jared 2012-10-09
USAGE = 'ruby extract_story_dates.rb [csv file] [cutoff date]'

# Configuration
DATE_OUTPUT_FORMAT = '%Y-%m-%d'
TAB = "\t"

def main
  # Usage
  die("Usage: " + USAGE) unless ARGV.length == 2

  # Check dependency on CSV library
  begin
    raise LoadError unless require 'csv'
  rescue LoadError
    die "Require 'csv' failed.  Check your ruby."
  end

  # Check that file exists
  csv_file = ARGV[0]
  die "File not found: #{csv_file}" unless File.exists?(csv_file)

  # Check that second argument is a date
  begin
    cutoff_date = Date.parse(ARGV[1])
  rescue ArgumentError
    die "Invalid date: #{ARGV[1]}"
  end

  # Dates have the form: Jun 5, 2012
  date_rgx = /[A-Z][a-z]{2}[ ][0-9]{1,2},[ ][0-9]{4}/

  # Read and output in the form: ID, pass/fail, most recent date
  CSV.foreach(csv_file, :headers => true) do |row|
    story_id = row[0]
    story_title = row[1]
    smushed = row.drop(1).join('')
    dates = smushed.scan(date_rgx).map{|d| Date.parse(d)}
    latest_date = dates.sort.last
    pass = latest_date >= cutoff_date
    date_output = latest_date.strftime(DATE_OUTPUT_FORMAT) rescue ''
    puts [date_output, pass, story_id, story_title].join(TAB)
  end
end

def die str
  $stderr.puts str
  exit 1
end

main
