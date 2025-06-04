#!/bin/bash

for f in frame-*.png; do
  convert "$f" -resize 512x512 -blur 0x1 -threshold 60% "tmp-${f%.png}.pgm"
done

for f in tmp-frame-*.pgm; do
  base="${f#tmp-}"     
  name="${base%.pgm}"  
  potrace "$f" -s --alphamax 1 -o "$name.svg"
done
