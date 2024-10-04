#!/usr/bin/env bash
cd ~/Pictures/Wallpapers/
while true; do
  file="$(ls *.jpg | sort -R | tail -1)"
  swww img "$file" --transition-fps 165 --transition-type none
  sleep 300
done
