#!/usr/bin/env bash

function jb_npm_page() {
  local package_name="$1"
  open "https://npmjs.org/package/$package_name"
}
