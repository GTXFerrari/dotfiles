#!/usr/bin/env bash

killall waybar

if [[ $USER == "jake" ]]; then
  waybar -c ~/.config/waybar/config.jsonc &
  -s ~/.config/waybar/style.css
else
  waybar &
fi
