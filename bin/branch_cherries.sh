#!/usr/bin/env bash

for branch in $(git for-each-ref --format='%(refname)' refs/heads/); do
  n=$(echo "$branch" | cut -d '/' -f 3) 
  git co -q "$n"
  lines=$(git cherry master | wc -l)
  printf "%d %s\n" "$lines" "$n" 
  git co -q master
done

