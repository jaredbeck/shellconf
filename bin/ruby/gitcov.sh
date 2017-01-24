#!/usr/bin/env bash
set -e
COVERAGE_REPORT='coverage/results.csv'
SHA=$1
FILES=$( git diff-tree --no-commit-id --name-only -r $SHA )
for i in $FILES; do grep "$i" "$COVERAGE_REPORT"; done |
  tr ',' "\t" |
  awk '{ print $2 "\t" $1 }'
