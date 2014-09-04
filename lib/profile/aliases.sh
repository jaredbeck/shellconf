#!/usr/bin/env bash

# General
alias l="clear; ls -l"
alias cdl="cd \!^; clear; ls -l"
alias abspath="$SHELLCONF_PATH/bin/abspath.rb"

# Quick SCM commands
alias a='git add --all .'
alias c='git commit'
alias d='git diff --patience'
alias s='clear;git status'
alias p='git push'
alias po="git push --set-upstream origin \"\$(git rev-parse --abbrev-ref HEAD)\""
alias gprp='git pull --rebase && git push'

# Git Log: Favorite formats
alias gl="git log --oneline --decorate"
alias gld="git log --date=iso "\
"--pretty=format:'%C(auto)%h %C(dim)%<(10,mtrunc)%an %ad "\
"%<(10,mtrunc)%cn %cd %Creset%C(auto)%d %s'"

# Github
alias hubpr="hub pull-request"

# Switch between java environments
alias usejava6='export JAVA_HOME=$(/usr/libexec/java_home -v 1.6);PATH=${JAVA_HOME}/bin:${PATH}'
alias usejava7='export JAVA_HOME=$(/usr/libexec/java_home -v 1.7);PATH=${JAVA_HOME}/bin:${PATH}'
alias usejava8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8);PATH=${JAVA_HOME}/bin:${PATH}'

# Ruby dev
alias be='bundle exec'
alias cuke='bundle exec cucumber'

# Dwarf Fortress
alias dwarf='/opt/df_linux/df'
alias dfbackup='~/git/jaredbeck/shellconf/bin/df/dfbackup.sh'
alias dfrestore='~/git/jaredbeck/shellconf/bin/df/dfrestore.sh'
