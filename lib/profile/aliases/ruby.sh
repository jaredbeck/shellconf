#!/usr/bin/env bash

source "$SHELLCONF_PATH/lib/jb_gem_versions.sh"
source "$SHELLCONF_PATH/lib/jb_rubygem_page.sh"

alias abc='bin/rubocop --only "Metrics/AbcSize" --config /dev/null'
alias be='bundle exec'
alias brs='bin/rails server'
alias brc='bin/rails console'
alias brubocop='bin/rubocop'
alias brubocopa='bin/rubocop -A'
alias gem_versions=jb_gem_versions
alias gitcov="$SHELLCONF_PATH/bin/ruby/gitcov.sh"
alias rg="jb_rubygem_page"
alias dotodo="ruby $SHELLCONF_PATH/bin/ruby/do_rubocop_todos.rb"
