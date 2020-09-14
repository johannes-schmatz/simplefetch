#!/bin/bash

# Arch Linux
# arch_linux.sh

color_base=$C_L_CYAN
color_label=$color_base
local color0=$C_CYAN
ascii=(
'                   -`                  '
'                  .o+`                 '
'                 `ooo/                 '
'                `+oooo:                '
'               `+oooooo:               '
'               -+oooooo+:              '
'             `/:-:++oooo+:             '
'            `/++++/+++++++:            '
'           `/++++++++++++++:           '
'          `/+++o'"${color0}"'oooooooo'"${color_base}"'oooo/`         '
'        ./'"${color0}"'ooosssso++osssssso'"${color_base}"'+`         '
"${color0}"'        .oossssso-````/ossssss+`       '
"${color0}"'       -osssssso.      :ssssssso.      '
"${color0}"'      :osssssss/        osssso+++.     '
"${color0}"'     /ossssssss/        +ssssooo/-     '
"${color0}"'   `/ossssso+/:-        -:/+osssso+-   '
"${color0}"'  `+sso+:-`                 `.-/+oso:  '
"${color0}"' `++:.                           `-/+/ '
"${color0}"' .`                                 `/ '
)

get_len_from 0
#get_len_set 42

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
