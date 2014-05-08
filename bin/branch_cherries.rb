#!/usr/bin/env ruby

FMT = '%d %s'
LINE_SEP = "\n"

def local_branches
  `git for-each-ref --format='%(refname)' refs/heads/ |
  cut -d '/' -f 3`
  .split(LINE_SEP)
end

def commits_ahead(branch)
  `git cherry master #{branch} |
  wc -l`
  .to_i
end

def main
  local_branches.each { |b| puts FMT % [commits_ahead(b), b] }
end

main
