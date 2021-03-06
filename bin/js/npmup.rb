#!/usr/bin/env ruby
# frozen_string_literal: true

require 'English'
require 'json'

# Updates a single NPM package and makes a git commit
# with a useful message, e.g. "left-pad 1.2.3 (was 1.2.2)".
module Npmup
  class CannotDetermineVersion < RuntimeError
    def initialize(package_name)
      super
      @package_name = package_name
    end

    def message
      "Cannot determine version of package: #{@package_name}"
    end
  end

  class CLI
    USAGE = "Usage: npmup.rb package_name"

    def initialize(*args)
      abort(USAGE) unless args.length == 1
      @package_name = args[0]
    end

    def run
      abort("repo is not clean") unless repo_clean?
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

    # Of course, the lockfile (npm-shrinkwrap.json) will be modified and must
    # be committed. Also (starting with npm 5?) package.json will be modified;
    # the package version will be updated. So, that must also be committed.
    def git_add
      `git add package.json npm-shrinkwrap.json`
    end

    def git_commit(message)
      `git commit -m "#{message}"`
    end

    def message(v1, v2)
      format "%s %s (was %s)", @package_name, v2, v1
    end

    def repo_clean?
      `git status --porcelain`.strip.empty?
    end

    def update
      `npm update #{@package_name}`
      unless $CHILD_STATUS.success?
        abort "npm update failed"
      end

      # Explicitly running shrinkwrap is not necessary in npm >= 5
      `npm shrinkwrap`
      unless $CHILD_STATUS.success?
        abort "npm shrinkwrap failed"
      end
    end

    def version
      stdout = `npm ls --json #{@package_name}`
      if !$CHILD_STATUS.success? || stdout.strip.empty?
        raise CannotDetermineVersion.new(@package_name)
      end
      version = ::JSON.parse(stdout)['dependencies'][@package_name]['version']
      unless version =~ /\A(\d+\.){2}\d+\Z/
        raise CannotDetermineVersion.new(@package_name)
      end
      version
    rescue CannotDetermineVersion => e
      abort(e.message)
    end
  end
end

Npmup::CLI.new(*ARGV).run
