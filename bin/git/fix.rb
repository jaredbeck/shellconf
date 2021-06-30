#!/usr/bin/env ruby

# frozen_string_literal: true

require 'tty-prompt'

module Git
  def self.fix(sha)
    target = `git rev-parse "#{sha}"`
    `git commit --fixup=#{target} ${@:2} && EDITOR=true git rebase -i --autostash --autosquash #{target}`
  end

  def self.log
    `git log --format=format:'%h %s' --max-count=100`
  end

  def self.staged
    `git diff --cached`
  end
end

class GitFix
  def self.call(argv = [])
    abort('Nothing is staged. Stage files before fixing.') if Git.staged == ''

    if argv.empty?
      prompt = TTY::Prompt.new
      commits = Git.log.split("\n")
      selected = prompt.
        select('Choose commit to fix', commits, filter: true, per_page: 10).
        match(/^(?<sha>\w*) (?<msg>.*)$/)
      Git.fix(selected[:sha])
    else
      Git.fix(argv.first)
    end
  end
end

begin
  GitFix.call(ARGV)
rescue SignalException
 print "\n"
end
