#! /usr/bin/bash
input=${1}.png

convert $input -crop 32x32+0+0 "${input}_00.png"
convert $input -crop 32x32+32+0 "${input}_01.png"
convert $input -crop 32x32+64+0 "${input}_02.png"

convert $input -crop 32x32+0+32 "${input}_10.png"
convert $input -crop 32x32+32+32 "${input}_11.png"
convert $input -crop 32x32+64+32 "${input}_12.png"

convert $input -crop 32x32+0+64 "${input}_20.png"
convert $input -crop 32x32+32+64 "${input}_21.png"
convert $input -crop 32x32+64+64 "${input}_22.png"
