#!/usr/bin/env bash

# NOTE: this script uses bash (not POSIX shell) for the RANDOM variable

if [[ $# -lt 1 ]] || [[ ! -d $1 ]]; then
  echo "Usage:
	$0 <dir containing images>"
  exit 1
fi

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=165
export SWWW_TRANSITION_STEP=2
export SWWW_TRANSITION_TYPE=random

# This controls (in seconds) when to switch to the next image
INTERVAL=300

while true; do
  find "$1" |
    while read -r img; do
      echo "$((RANDOM % 1000)):$img"
    done |
    sort -n | cut -d':' -f2- |
    while read -r img; do
      if [[ "$img" != "$1" ]]; then
        swww img "$img"
        sleep $INTERVAL
      fi
    done
done
