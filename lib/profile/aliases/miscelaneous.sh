#!/usr/bin/env bash

alias l="clear; ls -l"
alias cdl="cd \!^; clear; ls -l"
alias abspath="$SHELLCONF_PATH/bin/abspath.rb"
alias timestamp='date "+%Y%m%d%H%M%S"'
alias isodate='date +%FT%T%z'
alias lipsum='ruby -r faker -e "puts Faker::Lorem.paragraph" | pbcopy'
