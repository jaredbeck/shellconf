# Include me in your ~/.zshrc like this:
# SHELLCONF_PATH=$HOME/git/jaredbeck/shellconf
# if [ -f $SHELLCONF_PATH/zshrc.sh ]; then source $SHELLCONF_PATH/zshrc.sh; fi

# Enable the comment operator for interactive shells
# https://unix.stackexchange.com/a/557490/47089
setopt interactive_comments

# Path.  Only put path components available on all systems here.
# System-specific path components should go in ~/.zshrc
export PATH=~/bin:${PATH}

# Apple puts the java_home utility in /usr/libexec, even though that is
# for "binaries that are not intended to be executed directly by users"
# http://www.linuxbase.org/betaspecs/fhs/fhs/ch04s07.html
export PATH=${PATH}:/usr/libexec

# Favorite editor
export EDITOR=vi

# ## TTY options
# Remove `/` from `WORDCHARS`, because I want the `werase` control-character
# (eg. `^W`) to work the way it used to, in bash.
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Add identity to my SSH agent
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

# Ruby
eval "$(rbenv init -)"
export DISABLE_SPRING=1

# prompt
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
# [format](https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html)
JB_GIT_PROMPT_PATH=~/code/git/contrib/completion/git-prompt.sh
if [ -f "$JB_GIT_PROMPT_PATH" ]; then
  source "$JB_GIT_PROMPT_PATH";
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWCOLORHINTS=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWUPSTREAM="verbose"
  setopt PROMPT_SUBST ; PS1='$? %* %c $(__git_ps1 "(%s)") '
fi
