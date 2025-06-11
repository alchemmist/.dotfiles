#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_file output_file"
    exit 1
fi

input_file="$1"
output_file="$2"

magick "$input_file" \
  \( +clone -alpha extract \
     -draw "fill black polygon 0,0 0,%[fx:min(w,h)*0.03] %[fx:min(w,h)*0.03],0 fill white circle %[fx:min(w,h)*0.03],%[fx:min(w,h)*0.03] %[fx:min(w,h)*0.03],0" \
     \( +clone -flip \) -compose Multiply -composite \
     \( +clone -flop \) -compose Multiply -composite \
  \) \
  -alpha off -compose CopyOpacity -composite "$output_file"

