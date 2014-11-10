#!/usr/bin/env bash

function jb_extract_gem_versions() {
  echo "$1" | grep -o '\((.*)\)$' | tr -d '() ' | tr ',' "\n";
}
