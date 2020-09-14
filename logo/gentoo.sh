#!/bin/bash

# Gentoo
# gentoo.sh

color_base=$C_L_PURPLE
color_label=$color_base
local color0=$C_WHITE
ascii=(
'         -/oyddmdhs+:.               '
'     -o'"${color0}"'dNMMMMMMMMNNmhy+'"${color_base}"'-`            '
'   -y'"${color0}"'NMMMMMMMMMMMNNNmmdhy'"${color_base}"'+-          '
' `o'"${color0}"'mMMMMMMMMMMMMNmdmmmmddhhy'"${color_base}"'/`       '
' om'"${color0}"'MMMMMMMMMMMN'"${color_base}"'hhyyyo'"${color0}"'hmdddhhhd'"${color_base}"'o`     '
'.y'"${color0}"'dMMMMMMMMMMd'"${color_base}"'hs++so/s'"${color0}"'mdddhhhhdm'"${color_base}"'+`   '
' oy'"${color0}"'hdmNMMMMMMMN'"${color_base}"'dyooy'"${color0}"'dmddddhhhhyhN'"${color_base}"'d.  '
'  :o'"${color0}"'yhhdNNMMMMMMMNNNmmdddhhhhhyym'"${color_base}"'Mh  '
'    .:'"${color0}"'+sydNMMMMMNNNmmmdddhhhhhhmM'"${color_base}"'my  '
'       /m'"${color0}"'MMMMMMNNNmmmdddhhhhhmMNh'"${color_base}"'s:  '
'    `o'"${color0}"'NMMMMMMMNNNmmmddddhhdmMNhs'"${color_base}"'+\`  '
'  `s'"${color0}"'NMMMMMMMMNNNmmmdddddmNMmhs'"${color_base}"'/.     '
' /N'"${color0}"'MMMMMMMMNNNNmmmdddmNMNdso'"${color_base}"':`       '
'+M'"${color0}"'MMMMMMNNNNNmmmmdmNMNdso'"${color_base}"'/-          '
'yM'"${color0}"'MNNNNNNNmmmmmNNMmhs+/'"${color_base}"'-`            '
'/h'"${color0}"'MMNNNNNNNNMNdhs++/'"${color_base}"'-`               '
'`/'"${color0}"'ohdmmddhys+++/:'"${color_base}"'.`                  '
'  `-//////:--.                       '
)

#get_len_from 0
get_len_set 37

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
