#!/usr/bin/env bash

source "$SHELLCONF_PATH/lib/jb_echo_err.sh"
source "$SHELLCONF_PATH/lib/jb_heroku_follower_color.sh"

jb_heroku_psql_connect_follower() {
  local app="$1"
  local follower_color="$(jb_heroku_follower_color $app)"
  if [ -z "$follower_color" ]; then jb_echo_err 'Unable to determine follower color'; return 1; fi;
  heroku pg:psql "$follower_color" --app "$app"
}
