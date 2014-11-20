#!/usr/bin/env ruby

require 'set'

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

  # `deleteable` returns the names of deleteable branches.  The
  # ternary provides ruby 1.8.7 support.
  def deleteable
    b = deleteable_branches
    b.is_a?(Array) ? b.map(&:first) : b.keys
  end

  def deleteable_branches
    @_deleteable_branches ||= branches.select { |br, n| n.zero? }
  end

  def delete(branch)
    system("git branch --delete '%s' > /dev/null" % [branch])
  end

  def local_branch_array
    local_ref_array.map { |ref| ref.gsub(%r{\Arefs/heads/}, '') }
  end

  def local_branches
    Set.new(local_branch_array).delete('master')
  end

  def local_ref_array
    `git for-each-ref --format='%(refname)' refs/heads/`.split($/)
  end

  def commits_ahead(branch)
    `git cherry master #{branch} | wc -l`.to_i
  end

  def branch_commits_ahead
    local_branches.inject({}) { |hsh, br| hsh.update(br => commits_ahead(br)) }
  end
end

BranchCherries.new.run
