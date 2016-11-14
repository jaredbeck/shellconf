# Include me in your ~/.profile like this:
# SHELLCONF_PATH=$HOME/git/jaredbeck/shellconf
# if [ -f $SHELLCONF_PATH/profile.sh ]; then source $SHELLCONF_PATH/profile.sh; fi

SHELLCONF_PATH=$HOME/git/jaredbeck/shellconf

# tab completion
if [ -f $SHELLCONF_PATH/git-completion.bash ]; then
  source $SHELLCONF_PATH/git-completion.bash;
fi

# Path.  Only put path components available on all systems here.
# System-specific path components should go in ~/.profile
export PATH=~/bin:${PATH}

# Apple puts the java_home utility in /usr/libexec, even though that is
# for "binaries that are not intended to be executed directly by users"
# http://www.linuxbase.org/betaspecs/fhs/fhs/ch04s07.html
export PATH=${PATH}:/usr/libexec

# my favorite editor
export EDITOR=vi

# Add my identity to my SSH agent
SSH_ID_FILE="$HOME/.ssh/id_rsa"
if [ -f $SSH_ID_FILE ]; then
  ssh-add $SSH_ID_FILE
fi

# terminal colors
if [ -f /etc/issue ]; then
  alias ls="ls --color"
else
  export CLICOLOR=1
  export LSCOLORS="gxfxcxdxbxegedabagacad"
fi

# aliases
if [ -f $SHELLCONF_PATH/lib/profile/aliases.sh ]; then
  source $SHELLCONF_PATH/lib/profile/aliases.sh;
fi

# rails
export DISABLE_SPRING=1

# prompt
# ------

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
