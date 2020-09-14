#!/bin/bash

# satellite linux
# satellite_linux.sh

color_base=$C_L_CYAN
color_label=$C_GREEN
local color0=$C_L_RED
local color1=$C_L_BLUE

# satellite linux
ascii=(
	'(((|)))         '
	'   |            '
	' __|__  ['${color1}'|||||'${color_base}'] '
	'|     |_['${color1}'|||||'${color_base}'] '
	'|_____| ['${color1}'|||||'${color_base}'] ' 
	' \___/  ['${color1}'|||||'${color_base}'] '
	' /'${color0}'%%%'${color_base}'\          '
	'  '${color0}'%%            '
	'     '${color0}'%          '
	'  '${color0}'%             '
)

get_len_from 0
#get_len_set 42

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
