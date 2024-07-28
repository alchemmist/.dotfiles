#!/bin/bash

WMs=(
  "Hyprland"
  "sway"
)

selected_WM=$(printf "%s\n" "${WMs[@]}" | fzf --prompt="Select WM: ")

exec "$selected_WM"


