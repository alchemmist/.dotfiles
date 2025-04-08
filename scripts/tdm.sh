#!/bin/bash

WMs=(
  "Hyprland"
  "sway"
)

selected_WM=$(printf "%s\n" "${WMs[@]}" | fzf --prompt="Select WM: ")

export WM="$selected_WM"

cmatrix -b -u 1.7 & sleep 1.1; kill $!

exec "$selected_WM"
