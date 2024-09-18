#!/usr/bin/env bash
cd ~/Pictures/Wallpapers/
while :; do
  file="$(ls *.jpg | sort -R | tail -1)"
  swww img "$file" --transition-fps 120 --transition-type any
  sleep 300
done
