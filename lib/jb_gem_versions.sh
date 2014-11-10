#!/usr/bin/env bash

source "$SHELLCONF_PATH/lib/jb_extract_gem_versions.sh"

function jb_gem_versions() {
  local gem_name="$1";
  local pattern="^${gem_name}$";
  local vers_str="$(gem search ${pattern} --all)";
  jb_extract_gem_versions "$vers_str";
}
