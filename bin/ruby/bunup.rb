#!/usr/bin/env ruby
# frozen_string_literal: true

require 'English'
require 'rubygems'

if ::Gem::Version.new(RUBY_VERSION) < ::Gem::Version.new(2.3)
  abort "This script requires ruby >= 2.3"
end

# Updates a single gem using `bundle update` and makes a git commit
# with a useful message, e.g. "rails 4.2.4 (was 4.2.3)".
module Bunup
  class Gem

    # Gem name patterns taken from
    # https://github.com/rubygems/rubygems.org/blob/master/lib/patterns.rb
    SPECIAL_CHARACTERS = ".-_"
    ALLOWED_CHARACTERS = "[A-Za-z0-9#{Regexp.escape(SPECIAL_CHARACTERS)}]+"
    NAME_PATTERN       = /\A#{ALLOWED_CHARACTERS}\Z/

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def validate
      abort "Invalid gem name: #{@gem_name}" unless valid_name?
    end

    private

    def valid_name?
      !!(@name =~ NAME_PATTERN)
    end
  end

  class CLI
    E_CURRENT_VERSION_SAME = <<~EOS
      The current version, as determined by bundle show, is the same as the
      latest version, but we know that's wrong because bundle udpate changed
      the Gemfile.
    EOS
    E_UPDATE_CHANGED_NOTHING = <<~EOS
      bundle update did not change gemfile: %s
      Examine the version constraints in your Gemfile.
    EOS
    USAGE = "Usage: bunup.rb gem_name"

    def initialize(*args)
      abort(USAGE) unless args.length == 1
      gem_name = args[0]
      @gem = Gem.new(gem_name)
      @gem.validate
    end

    def run
      v1 = version
      update
      v2 = version
      git_add
      git_commit message(v1, v2)
    end

    private

    def assert_gemfile_changed(update_cmd)
      unless gemfile_changed?
        abort(format(E_UPDATE_CHANGED_NOTHING, update_cmd))
      end
    end

    def gem_name
      @gem.name
    end

    def git_add
      `git add Gemfile Gemfile.lock`
    end

    def git_commit(message)
      `git commit -m "#{message}"`
    end

    def gemfile_changed?
      stdout = `git status --porcelain`
      stdout.include?('M Gemfile') && stdout.include?('M Gemfile.lock')
    end

    def message(v1, v2)
      if v1 == v2
        puts E_CURRENT_VERSION_SAME
        v1 = prompt_for_version("Enter current version: ")
      end
      format "%s %s (was %s)", gem_name, v2, v1
    end

    def prompt_for_version(prompt)
      print prompt
      input = $stdin.gets&.chomp
      if input.nil? || input.empty? || !::Gem::Version.correct?(input)
        abort "Invalid entry: Incorrect gem version format"
      end
      input
    end

    def update
      cmd = "bundle update #{gem_name}"
      `#{cmd}`
      assert_gemfile_changed(cmd)
    end

    # Returns version of gem in bundle, by using `bundle show`, which produces
    # output like:
    #
    # ```
    # bundle show oj
    # /Users/jared/.rbenv/versions/2.2.3/lib/ruby/gems/2.2.0/gems/oj-2.12.14
    # ```
    #
    def version
      stdout = `bundle show #{gem_name}`
      if !$CHILD_STATUS.success? || stdout.strip.empty?
        puts "Unable to determine current version by using bundle show"
        puts stdout
        return prompt_for_version("Enter current version: ")
      end
      stdout.chomp.split(File::PATH_SEPARATOR).last.split('-').last
    end
  end
end

Bunup::CLI.new(*ARGV).run
