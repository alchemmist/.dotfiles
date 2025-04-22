#!/bin/bash

export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION=wave
export SWWW_TRANSITION_DURATION=2.5
export SWWW_TRANSITION_ANGLE=60
export WALLPAPER_PACK=nature

DIR="/home/alchemmist/Pictures/wallpapers/$WALLPAPER_PACK"

find "$DIR" -type f -o -type l \
  | while read -r img; do
    echo "$((RANDOM % 1000)):$img"
  done \
  | sort -n | cut -d':' -f2- \
  | while read -r img; do
    swww img "$img" 
    exit
  done

