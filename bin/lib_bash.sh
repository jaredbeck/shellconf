#!/bin/bash
set -e

function die {
  echo "$1" 1>&2
  exit 1
}

function assert_dir {
  if [ ! -d "$1" ]; then die "Directory not found: $1"; fi
}

function assert_file {
  if [ ! -f "$1" ]; then die "File not found: $1"; fi
}

