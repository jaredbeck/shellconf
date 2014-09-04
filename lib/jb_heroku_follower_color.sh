#!/usr/bin/env bash

source "$SHELLCONF_PATH/lib/jb_echo_err.sh"

# jb_heroku_follower_color - Returns the color of the follower
# database, or the empty string if there is none.
#
# $1 - heroku app name
#
jb_heroku_follower_color() {
  local app="$1"
  local prefix='HEROKU_POSTGRESQL_'
  local pattern="$prefix([A-Z]+)_URL"

  if [ -z "$app" ]; then
    jb_echo_err 'Usage: jb_heroku_follower_color <app>'
    return 1
  fi

  heroku pg:info --app "$app" |
    ggrep "$prefix" |
    ggrep -v DATABASE_URL |
    ggrep -Eo "$pattern" |
    sed -E "s/$pattern/\1/"
}
