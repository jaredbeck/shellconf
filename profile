# Include me in your ~/.profile like this:
# SHELLCONF_PATH=$HOME/git/jaredbeck/shellconf
# if [ -f $SHELLCONF_PATH/profile ]; then source $SHELLCONF_PATH/profile; fi

SHELLCONF_PATH=$HOME/git/jaredbeck/shellconf

# tab completion
if [ -f $SHELLCONF_PATH/git-completion.bash ]; then
  source $SHELLCONF_PATH/git-completion.bash;
fi

# Path.  Only put path components available on all systems here.
# System-specific path components should go in ~/.profile
export PATH=~/bin:${PATH}

# my favorite editor
export EDITOR=vi
export SVN_EDITOR=vi
export FAVORITE_EDITOR=bbedit

# terminal colors
if [ -f /etc/issue ]; then
  alias ls="ls --color"
else
  export CLICOLOR=1
  export LSCOLORS="gxfxcxdxbxegedabagacad"
fi

# Aliases: General
alias l="clear; ls -l"
alias cdl="cd \!^; clear; ls -l"

# Aliases: Quick SCM commands
alias a="if [ -d .svn ]; then svnadd; else git add --all .; fi"
alias c="if [ -d .svn ]; then svn ci; else git commit; fi"
alias d="if [ -d .svn ]; then svn diff; else git diff; fi"
alias s="if [ -d .svn ]; then svnst; else gitst; fi"
alias p="git push"
alias gprp="git pull --rebase && git push"

# Aliases: SCM commands, mostly used by aliases above
alias svnst='clear;svn status --ignore-externals | grep ^[^X]'
alias svnadd='svn status | grep ^? | sed "s/^\?      //" | (while read i; do svn add $i; done)'
alias svnrevert="svn stat | grep ^M | awk '{print $2}' | xargs -n 1 svn revert"
alias gitst='clear;git status'

# Aliases: Misc
alias be='bundle exec'
alias blockms='sudo ipfw add 0 deny udp from any to any 2222'
alias startwork='git pull --rebase && git submodule update --init && bundle update && be rake'

parse_git_branch() {
  ref=$(git symbolic-ref -q HEAD 2> /dev/null) || return
  printf "${1:-(%s)}" "${ref#refs/heads/}"
}

# Bash Color Chart
# http://www.arwin.net/tech/bash_colors.png
pimp_prompt() {
  local BLUE="\[\033[0;34m\]"
  local BLUE_BOLD="\[\033[1;34m\]"
  local CYAN="\[\033[0;36m\]"
  local RED="\[\033[0;31m\]"
  local LIGHT_RED="\[\033[1;31m\]"
  local GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local WHITE="\[\033[0;37m\]"
  local WHITE_BOLD="\[\033[1;37m\]"
  local LIGHT_GRAY="\[\033[0;37m\]"
  local DEFAULT="\[\033[0;39m\]"
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac

# 2011 style with user@host
#PS1="${TITLEBAR}$DEFAULT\u@\h \w$GREEN\$(parse_git_branch)$DEFAULT\$ "

# 2012 style with timestamp instead
PS1="${TITLEBAR}$DEFAULT$WHITE_BOLD\t $CYAN\h $WHITE\W $GREEN\$(parse_git_branch)$DEFAULT\$ "
PS2='> '
PS4='+ '
}
pimp_prompt
