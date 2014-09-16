#!/usr/bin/env ruby

require 'open3'
require 'pp'

module UpgradeBundle

  ANNOYING_PREFIX = '  * '
  ANNOYING_PREFIX_LEN = ANNOYING_PREFIX.length
  BUNDLE_OUTDATED = 'bundle outdated --no-color'
  BUNDLE_SUCCESS_STR = 'Outdated gems'
  SCRIPT_FILENAME = File.basename(__FILE__)
  TAB = "\t"

  class OutdatedGem

    # Example output from UpgradeBundle::BUNDLE_OUTDATED
    #
    #     * shoulda-matchers (2.7.0 > 2.6.2)
    #     * sidekiq (3.2.5 > 3.0.2) Gemfile specifies "< 3.1"
    #     * sidetiq (0.6.1 > 0.5.0 4f7d7da)
    #     * unicorn-rails (2.2.0 > 2.1.1)
    #
    # The constructor argument `outdated_version_tuple_str` is
    # the text inside the parens.
    #
    GVVP = Gem::Version::VERSION_PATTERN
    VERSION_TUPLE_DELIMITER = '>'

    attr_reader :name, :new_vers, :old_vers

    def initialize(name, outdated_version_tuple_str)
      @name = name
      @new_vers, @old_vers = parse(outdated_version_tuple_str)
    end

    def parse(version_tuple)
      return *version_tuple                   # e.g. (0.6.1 > 0.5.0 4f7d7da)
        .delete('()')                         # e.g. 0.6.1 > 0.5.0 4f7d7da
        .split(VERSION_TUPLE_DELIMITER)       # e.g. ['0.6.1', '0.5.0 4f7d7da']
        .map { |v| v.strip.match(GVVP).to_s } # e.g. ['0.6.1', '0.5.0']
        .map { |v| Gem::Version.new(v) }
    end

    def patch?
      ovs = old_vers.segments
      nvs = new_vers.segments
      ovs[0] == nvs[0] && ovs[1] == nvs[1] && ovs[2] != nvs[2]
    end

    def semver?
      old_vers.segments.length == 3 && new_vers.segments.length == 3
    end

    def to_s
      "#{@name} (#{@new_vers.to_s} > #{@old_vers.to_s})"
    end
  end

  class << self
    def run(argv)
      check_args(argv)
      verbose, file_path = parse_args(argv)
      file = file_path.nil? ? nil : File.new(file_path)
      gems = parse(bo_output(file))
      print_patches(gems, verbose)
    end

    private

    def bo_output(file)
      file.nil? ? bundle_outdated : file.read
    end

    def bundle_outdated
      puts "Running: #{BUNDLE_OUTDATED}"
      puts 'This can take a while, especially for big `Gemfile`s'
      stdout_str, stderr_str, status = Open3.capture3(BUNDLE_OUTDATED)
      $stderr.puts(stderr_str)
      if status.success?
        puts 'Your bundle is totally up to date!  We\'re done here.'
        exit(0)
      elsif !stdout_str.include?(BUNDLE_SUCCESS_STR)
        bundle_outdated_has_failed(status)
      end
      stdout_str
    end

    def bundle_outdated_has_failed(status)
      msg = "Error: `#{BUNDLE_OUTDATED}` probably failed: " +
        "Not found in stdout: \"#{BUNDLE_SUCCESS_STR}\""
      die(msg, status.exitstatus)
    end

    def check_args(argv)
      if argv.length > 2
        print_usage
        exit(1)
      end
    end

    def die(msg, status_code)
      $stderr.puts(msg)
      exit(status_code.to_i)
    end

    def parse(bo_output)
      bo_output.lines.select { |line|
        line[0, ANNOYING_PREFIX_LEN] == ANNOYING_PREFIX
      }.map { |line|
        line[ANNOYING_PREFIX_LEN, line.length - ANNOYING_PREFIX_LEN].chomp
      }.map { |line|
        fields = line.split(' ', 2)
        OutdatedGem.new(fields[0], /\A\([^)]+\)/.match(fields[1]).to_s)
      }
    end

    # TODO: Find a library for parsing CLI options .. yuck
    def parse_args(argv)
      if argv.length == 0
        verbose = false
        file_path = nil
      elsif argv.length == 1
        if argv[0] == '-v'
          verbose = true
          file_path = nil
        else
          verbose = false
          file_path = argv[0]
        end
      elsif argv.length == 2
        if argv[0] == '-v'
          verbose = true
          file_path = argv[1]
        else
          print_usage
          exit(1)
        end
      end
      return verbose, file_path
    end

    def print_patches(gems, verbose)
      gems.each do |g|
        if !g.semver?
          puts "Skip: Not SEMVER: #{g}" if verbose
        elsif g.patch?
          if verbose
            puts "Patch: #{g}"
          else
            puts g.name
          end
        else
          puts "Not Patch: #{g}" if verbose
        end
      end
    end

    def print_usage
      puts "Usage: ruby #{SCRIPT_FILENAME} [-v] [file]"
      puts
      puts '       [-v] - Verbose'
      puts '       [file] - Useful for quick debugging, development.'
      puts "                Contains output of `#{BUNDLE_OUTDATED}`"
      puts
    end
  end
end

UpgradeBundle.run(ARGV)
