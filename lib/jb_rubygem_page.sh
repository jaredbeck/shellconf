#!/usr/bin/env bash

function jb_rubygem_page() {
  local gemname="$1"
  open "https://rubygems.org/gems/$gemname"
}

