# Aliases: General
alias l="clear; ls -l"
alias cdl="cd \!^; clear; ls -l"
alias abspath="$SHELLCONF_PATH/bin/abspath.rb"

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

# Aliases: to switch between java environments
alias usejava6='export JAVA_HOME=$(/usr/libexec/java_home -v 1.6);PATH=${JAVA_HOME}/bin:${PATH}'
alias usejava7='export JAVA_HOME=$(/usr/libexec/java_home -v 1.7);PATH=${JAVA_HOME}/bin:${PATH}'
alias usejava8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8);PATH=${JAVA_HOME}/bin:${PATH}'

# Aliases: Ruby dev
alias be='bundle exec'
alias startwork='git pull --rebase && git submodule update --init && bundle update && be rake'

# Aliases: Dwarf Fortress
alias dwarf='/opt/df_linux/df'
alias dfbackup='~/git/jaredbeck/shellconf/bin/df/dfbackup.sh'
alias dfrestore='~/git/jaredbeck/shellconf/bin/df/dfrestore.sh'

# Aliases: Misc
alias blockms='sudo ipfw add 0 deny udp from any to any 2222'
