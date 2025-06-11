#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_file output_file"
    exit 1
fi

input_file="$1"
output_file="$2"

magick "$input_file" \
  \( +clone -alpha extract -blur 0x15 -background black -shadow 15x15+0+0 \) \
  +swap -background none -layers merge -gravity center -extent '%[fx:w+15]x%[fx:h+15]' \
  "$output_file"
