#!/usr/bin/env ruby
require 'English'
require 'json'

# Updates a single NPM package, using yarn, and makes a git commit
# with a useful message, e.g. "left-pad 1.2.3 (was 1.2.2)".
module YarnUp
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
    USAGE = "Usage: yarnup.rb package_name"

    def initialize(*args)
      abort(USAGE) unless args.length == 1
      @package_name = args[0]
    end

    def run
      abort("repo is not clean") unless repo_clean?
      v1 = version
      upgrade
      v2 = version
      git_add
      git_commit message(v1, v2)
    end

    private

    def gem_name
      @gem.name
    end

    # Of course, the lockfile will be modified and must be committed. Also
    # package.json will be modified; the package version will be updated. So,
    # that must also be committed.
    def git_add
      `git add package.json yarn.lock`
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

    def upgrade
      `yarn upgrade #{@package_name}`
      unless $CHILD_STATUS.success?
        abort "yarn upgrade failed"
      end
    end

    def version
      pkg_info = yarn_info.find { |pkg| pkg.fetch(:name) == @package_name }
      if pkg_info.nil?
        raise CannotDetermineVersion.new(@package_name)
      end
      version = pkg_info.fetch(:version)
      unless version =~ /\A(\d+\.){2}\d+\Z/
        raise CannotDetermineVersion.new(@package_name)
      end
      version
    rescue CannotDetermineVersion => e
      abort(e.message)
    end

    # Returns an array of currently installed packages.
    # The array structure is, e.g.
    #
    # ```
    # [
    #   {
    #     name: 'left-pad',
    #     version: '1.2.3'
    #   }
    # ]
    # ```
    def yarn_info
      stdout = `yarn list --json #{@package_name}`
      if !$CHILD_STATUS.success? || stdout.strip.empty?
        raise CannotDetermineVersion.new(@package_name)
      end
      ::JSON.
        parse(stdout).
        fetch('data').
        fetch('trees').
        map { |tree|
          yarn_name = tree.fetch('name')
          name_parts = yarn_name.split('@')
          unless name_parts.length == 2
            raise "Unexpected name format: #{yarn_name}"
          end
          {
            name: name_parts[0],
            version: name_parts[1]
          }
        }
    end
  end
end

YarnUp::CLI.new(*ARGV).run
