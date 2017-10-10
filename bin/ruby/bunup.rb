#!/usr/bin/env ruby

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

    def gem_name
      @gem.name
    end

    def git_add
      `git add Gemfile Gemfile.lock`
    end

    def git_commit(message)
      `git commit -m "#{message}"`
    end

    def message(v1, v2)
      format "%s %s (was %s)", gem_name, v2, v1
    end

    def update
      `bundle update #{gem_name}`
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
      cmd = "bundle show #{gem_name}"
      stdout = `#{cmd}`
      if !$?.success? || stdout.strip.empty?
        abort(
          format(
            "Unable to determine current version of gem: %s\nCommand was: %s",
            gem_name,
            cmd
          )
        )
      end
      stdout.chomp.split(File::PATH_SEPARATOR).last.split('-').last
    end
  end
end

Bunup::CLI.new(*ARGV).run
