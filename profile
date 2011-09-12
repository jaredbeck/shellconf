# Include me in your ~/.profile like this:
# if [ -f ~/git/shellconf/profile ]; then source ~/git/shellconf/profile; fi

# my favorite editor
export SVN_EDITOR=vi
export FAVORITE_EDITOR=bbedit

# terminal colors
LSCOLORS="gxfxcxdxbxegedabagacad"
export LSCOLORS

# aliases
alias l="clear; ls -lG"
alias cdl="cd \!^; clear; ls -l"

alias svnst='clear;svn status --ignore-externals | grep ^[^X]'
alias svnadd='svn status | grep ^? | sed "s/^\?      //" | (while read i; do svn add $i; done)'
alias svnrevert="svn stat | grep ^M | awk '{print $2}' | xargs -n 1 svn revert"

alias gitst='clear;git status'

# quick SCM commands
alias a="if [ -d .svn ]; then svnadd; else git add -A; fi"
alias c="if [ -d .svn ]; then svn ci; else git commit; fi"
alias d="if [ -d .svn ]; then svn diff; else git diff --cached; fi"
alias s="if [ -d .svn ]; then svn stat; else git status; fi"

alias blockms='sudo ipfw add 0 deny udp from any to any 2222'

parse_git_branch() {
  ref=$(git symbolic-ref -q HEAD 2> /dev/null) || return
  printf "${1:-(%s)}" "${ref#refs/heads/}"
}

parse_svn_revision() {
  local DIRTY REV=$(svn info 2>/dev/null | grep Revision | sed -e 's/Revision: //')
  [ "$REV" ] || return
  [ "$(svn st)" ] && DIRTY=' *'
  echo "(r$REV$DIRTY)"
}

pimp_prompt() {
  local BLUE="\[\033[0;34m\]"
  local BLUE_BOLD="\[\033[1;34m\]"
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
#PS1="${TITLEBAR}[$WHITE\u@$BLUE_BOLD\h$WHITE \w$GREEN\$(parse_git_branch)\$(parse_svn_revision) $RED\$(~/.rvm/bin/rvm-prompt v g)$WHITE]\$ "
#PS1="${TITLEBAR}[$WHITE\u@$BLUE_BOLD\h$WHITE \w$GREEN\$(parse_git_branch)\$(parse_svn_revision)$WHITE]\$ "
PS1="${TITLEBAR}$DEFAULT\u@\h \w$GREEN\$(parse_git_branch)$DEFAULT\$ "
PS2='> '
PS4='+ '
}
pimp_prompt
