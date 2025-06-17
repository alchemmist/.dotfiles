#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_file output_file"
    exit 1
fi

input_file="$1"
output_file="$2"

magick "$input_file" \
  \( +clone -alpha extract -blur 0x15 -background black -shadow 35x35+0+0 \) \
  +swap -background none -layers merge -gravity center -extent '%[fx:w+35]x%[fx:h+35]' \
  "$output_file"
