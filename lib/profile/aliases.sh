#!/usr/bin/env bash

# General
alias l="clear; ls -l"
alias cdl="cd \!^; clear; ls -l"
alias abspath="$SHELLCONF_PATH/bin/abspath.rb"

# Quick SCM commands
alias a="if [ -d .svn ]; then svnadd; else git add --all .; fi"
alias c="if [ -d .svn ]; then svn ci; else git commit; fi"
alias d="if [ -d .svn ]; then svn diff; else git diff --patience; fi"
alias s="if [ -d .svn ]; then svnst; else gitst; fi"
alias p="git push"
alias po="git push --set-upstream origin \"\$(git rev-parse --abbrev-ref HEAD)\""
alias gprp="git pull --rebase && git push"

# Git Log: Favorite formats
alias gl="git log --oneline --decorate"
alias gld="git log --date=iso "\
"--pretty=format:'%C(auto)%h %C(dim)%<(10,mtrunc)%an %ad "\
"%<(10,mtrunc)%cn %cd %Creset%C(auto)%d %s'"

# SCM commands, mostly used by aliases above
alias svnst='clear;svn status --ignore-externals | grep ^[^X]'
alias svnadd='svn status | grep ^? | sed "s/^\?      //" | (while read i; do svn add $i; done)'
alias svnrevert="svn stat | grep ^M | awk '{print $2}' | xargs -n 1 svn revert"
alias gitst='clear;git status'

# to switch between java environments
alias usejava6='export JAVA_HOME=$(/usr/libexec/java_home -v 1.6);PATH=${JAVA_HOME}/bin:${PATH}'
alias usejava7='export JAVA_HOME=$(/usr/libexec/java_home -v 1.7);PATH=${JAVA_HOME}/bin:${PATH}'
alias usejava8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8);PATH=${JAVA_HOME}/bin:${PATH}'

# Ruby dev
alias be='bundle exec'
alias cuke='bundle exec cucumber'
alias startwork='git pull --rebase && git submodule update --init && bundle update && be rake'

# Dwarf Fortress
alias dwarf='/opt/df_linux/df'
alias dfbackup='~/git/jaredbeck/shellconf/bin/df/dfbackup.sh'
alias dfrestore='~/git/jaredbeck/shellconf/bin/df/dfrestore.sh'

# Misc
alias blockms='sudo ipfw add 0 deny udp from any to any 2222'
