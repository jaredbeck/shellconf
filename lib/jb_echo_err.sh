#!/usr/bin/env bash

jb_echo_err() {
  local msg="$1"
  if [ -z "$msg" ]; then msg='Unspecified Error'; fi;
  echo "$msg" >&2
}
