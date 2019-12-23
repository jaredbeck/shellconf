#!/usr/bin/env bash

# Git Basics
# ----------

alias a='git add --all .'
alias c='git commit'
alias ca='git commit --amend --no-edit'
alias d='git diff --patience'
alias s='clear;git status'
alias p='git push'
alias po="git push --set-upstream origin \"\$(git rev-parse --abbrev-ref HEAD)\""
alias gprp='git pull --rebase && git push'
alias brch="$SHELLCONF_PATH/bin/branch_cherries.rb"
alias gscop="git show --name-only --pretty='' | xargs bin/rubocop"

# Git Log
# -------

alias gl="git log --oneline --decorate"

# gld - Like `gl`, but with author date.  Quite wide.
alias gld="git log --date=iso "\
"--pretty=format:'%C(auto)%h %C(dim)%<(10,mtrunc)%an %ad "\
"%Creset%C(auto)%d %s'"

# gldd - Like `gld`, but with commit date.  Very wide.
alias gldd="git log --date=iso "\
"--pretty=format:'%C(auto)%h %C(dim)%<(10,mtrunc)%an %ad "\
"%<(10,mtrunc)%cn %cd %Creset%C(auto)%d %s'"

# Github
# ------
alias hubpr="hub pull-request"
