#!/usr/bin/env bash

# Switch between java environments
alias usejava6='export JAVA_HOME=$(/usr/libexec/java_home -v 1.6);PATH=${JAVA_HOME}/bin:${PATH}'
alias usejava7='export JAVA_HOME=$(/usr/libexec/java_home -v 1.7);PATH=${JAVA_HOME}/bin:${PATH}'
alias usejava8='export JAVA_HOME=$(/usr/libexec/java_home -v 1.8);PATH=${JAVA_HOME}/bin:${PATH}'
