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

# JS
export PATH="/usr/local/opt/node@10/bin:$PATH"

# prompt
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'
