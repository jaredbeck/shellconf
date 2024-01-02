#!/usr/bin/env bash

alias l="clear; ls -l"
alias cdl="cd \!^; clear; ls -l"
alias abspath="$SHELLCONF_PATH/bin/abspath.rb"
alias isodate='date "+%Y-%m-%d"'
alias lipsum='ruby -r faker -e "puts Faker::Lorem.paragraph" | pbcopy'
alias pbsort='pbpaste | sort | pbcopy'

# Timestamp (TS)
alias ts='date -u "+%Y-%m-%dT%H:%M:%SZ"' # UTC, ISO-8601
alias tslocal='date "+%Y-%m-%d %H:%M %Z"' # Local zone, minutes precision
alias tsnd='date "+%Y%m%d%H%M%S"' # ND = No Delimiter
