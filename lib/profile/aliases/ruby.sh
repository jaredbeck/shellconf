#!/usr/bin/env bash

source "$SHELLCONF_PATH/lib/jb_gem_versions.sh"
source "$SHELLCONF_PATH/lib/jb_rubygem_page.sh"

alias be='bundle exec'
alias brs='bin/rails server'
alias brc='bin/rails console'
alias gem_versions=jb_gem_versions
alias rg="jb_rubygem_page"
alias gitcov="$SHELLCONF_PATH/bin/ruby/gitcov.sh"
