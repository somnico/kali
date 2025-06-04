#!/bin/bash

for f in frame-*.png; do
  convert "$f" -resize 512x512 -blur 0x2 -monochrome -dither FloydSteinberg "tmp-${f%.png}.pgm"
done

for f in tmp-frame-*.pgm; do
  base="${f#tmp-}"     
  name="${base%.pgm}"  
  potrace "$f" -s --alphamax 1 -o "$name.svg"
done
