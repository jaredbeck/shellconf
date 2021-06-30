#!/usr/bin/env bash

alias l="clear; ls -l"
alias cdl="cd \!^; clear; ls -l"
alias abspath="$SHELLCONF_PATH/bin/abspath.rb"
alias isodate='date "+%Y-%m-%d"'
alias lipsum='ruby -r faker -e "puts Faker::Lorem.paragraph" | pbcopy'

# Timestamp (TS) - commonly used for DCS release titles
alias ts='date "+%Y-%m-%d %H:%M %Z"'

# Timestamp No Delimiter (ND) - rarely used
alias tsnd='date "+%Y%m%d%H%M%S"'
