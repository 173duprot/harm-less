#!/usr/bin/env bash

exec 2> /dev/null

shopt -s nullglob
dir_count=0
file_count=0

traverse() {
  dir_count=$(($dir_count + 1))
  local directory=$1
  local prefix=$2

  local children=($directory/*)
  local child_count=${#children[@]}

  for idx in "${!children[@]}"; do
    local child=${children[$idx]// /\\ }
    child=${child##*/}

    local child_prefix="│   "
    local pointer="├── "

    if [ $idx -eq $((child_count - 1)) ]; then
      pointer="└── "
      child_prefix="    "
    fi

    echo "${prefix}${pointer}$child $(cat "$directory/$child")"
    [ -d "$directory/$child" ] &&
      traverse "$directory/$child" "${prefix}$child_prefix" ||
      file_count=$((file_count + 1))
  done
}

root="."
[ "$#" -ne 0 ] && root="$1"
echo $root

traverse $root ""
shopt -u nullglob
