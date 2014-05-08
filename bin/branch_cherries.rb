#!/usr/bin/env ruby

require 'set'

FMT = '%d %s'
LINE_SEP = "\n"

class BranchCherries

  attr_reader :branches

  def initialize
    @branches = branch_commits_ahead
  end

  def run
    puts '%d branches have commits not in master' % [ahead.size]
    puts '%d branches can be deleted.' % [deleteable.size]
    unless deleteable.empty?
      puts 'Deleteable: '
      deleteable.each { |br| puts '  ' + br }
      print 'Delete? [Y/n]: '
      choice = gets.chomp
      deleteable.each { |br| delete(br) } if choice == 'Y'
    end
  end

private

  def ahead
    branches.reject { |br, n| n.zero? }
  end

  def deleteable
    @_deleteable ||= branches.select { |br, n| n.zero? }.keys
  end

  def delete(branch)
    system('git branch --delete "%s" > /dev/null' % [branch])
  end

  def local_branch_array
    `git for-each-ref --format='%(refname)' refs/heads/ |
    cut -d '/' -f 3`
    .split(LINE_SEP)
  end

  def local_branches
    Set.new(local_branch_array).delete('master')
  end

  def commits_ahead(branch)
    `git cherry master #{branch} |
    wc -l`
    .to_i
  end

  def branch_commits_ahead
    local_branches.inject({}) { |hsh, br| hsh.update(br => commits_ahead(br)) }
  end
end

BranchCherries.new.run
