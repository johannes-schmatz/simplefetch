#!/bin/bash
#   simplefetch - a CLI Bash script to show system info
#
#   Copyright (c) 2010-2019  Brett Bohnenkamper <kittykatt@kittykatt.us>
#   Copyright (c) 2019-2020  Johannes Schmatz <johannes_schmatz@gmx.de>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Requires: bash 4.0+ (higher is better)

# use tabs!
# tabs are great!
# all brackets MUST be closed, so
# number of ( == number of )
# number of [ == number of ]
# number of { == number of }
# to check brackets in this script, use $0 --check

# don't wonder about the short lines. I improved this
# on Android.

# try this if it does not work
#LC_ALL=C

prog_name="simplefetch"
prog_version="0.1.0"

# use $true and $false
true=1
false=0

# use $unknown if content is not known
unknown="Unknown"

############# here starts the config section
## config: ##
#############

# -a option
# set to $unknown of not used
fake_art="$unknown"

# -t option
# 0 = full output not truncated
truncate=0

# comment out what you do not need.
function all_to_print(){
	print_user_hostname
	print_distribution
	print_kernel_version
	print_uptime
	print_package_count
	print_shell
	print_disk_usage
	print_cpu
	print_mem
	print_gpu
	#
	# add here your custom output
	#
	# replace 'label' and 'text' with your text.
	#
	output_add "label" "text"
	output_add_raw "label text"
}

# verbose setting
verbose=$false

# error print setting
error_print=$true

# $false ->  print colors
nocolor=$false

#############
## /config ##
############# end of config!
#
# here follows code, do NOT EDIT!
#

# static variables
supported_dist="Arch Linux (32), Gentoo, openSUSE \
Tumbleweed, Raspbian, satellite Linux"
# tab -> tab in var

# some output functions
function verb(){
	[[ $verbose == $true ]] && \
		echo "$prog_name: verbose: $@"
}

function error(){
	[[ $error_print == $true ]] && \
		echo "$prog_name: ERROR: $@" 1>&2
}

# some color codes for help/version
H_R=$'\e[0m' #]
H_B=$'\e[1m' #]
H_U=$'\e[4m' #]
H_BU=$'\e[1;4m' #]

# all functions
function prog_help(){
	cat <<helpeof
${H_BU}Usage${H_R}:
	${0} [${H_BU}OPTIONAL FLAGS${H_R}]

simplefetch - simpler screenfetch
version: $prog_version

${H_BU}Supported GNU/Linux Distributions${H_R}:
`fold -s <<< "$supported_dist" | sed 's/^/\t/g'`


${H_BU}Options${H_R}:
	${H_B}-v${H_R}
		Verbose output.
	${H_B}-n${H_R}
		Strip all color from output.
	${H_B}-a '${H_U}DISTRO${H_R}${H_B}'${H_R}
		Ascii-art to display.
	${H_B}-t '${H_U}truncate width${H_R}${H_B}'${H_R}
		Truncate text output to truncate width.
	${H_B}-V, --version${H_R}
		Display current script version/license
		information.
	${H_B}-h, --help${H_R}
		Display this help
	${H_B}--check${H_R}
		Check that all brackets are correct.
		The last opened bracket needs to be closed
		first. Then follows the second...
		There NOT MUST any closing brackets without
		the opening brackets.

Just for tools, that detect a program version:
name: ${0}
version: ${prog_version}
helpeof
	verb 'exiting.'
	exit 2
}

function prog_vers(){
	cat <<versioneof
${H_BU}simplefetch${H_R}
version ${H_U}${prog_version}${H_R}

simplefetch is created by
	Johannes Schmatz <johannes_schmatz@gmx.de>
on the work of screenfetch.

screenfetch was origally created by and licensed to
	Brett Bohnenkamper <kittykatt@kittykatt.us>

OS X porting done almost solely by
	shrx (https://github.com/shrx) and
	John D. Duncan, III (https://github.com/JohnDDuncanIII).

This is free software; see the source for copying
conditions.  There is NO warranty; not even
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Just for tools, that detect a program version:
name: ${0}
version: ${prog_version}
versioneof
	verb 'exiting.'
	exit 2
}

# function to check brackets
function prog_check_brackets(){
	local o_r='(' c_r=')'
	local o_s='[' c_s=']'
	local o_b='{' c_b='}'
	local c c_reverse
	local is_closing
	local b=( 0 )
	local l=( 0 )
	local line=1
	local ret=0

	cat "$1" | \
	sed '
		s/./\n\0/g;
		a==
	' | \
	while read c; do
		is_closing=$false
		is_bracket=$false
		case "$c" in #((((
			"$o_r"|"$o_s"|"$o_b")
				b=( "$c" "${b[@]}" )
				l=( "$line" "${l[@]}" )
			;;
			"$c_r")
				c_reverse="$o_r"
				is_closing=$true
			;;
			"$c_s")
				c_reverse="$o_s"
				is_closing=$true
			;;
			"$c_b")
				c_reverse="$o_b"
				is_closing=$true
			;;
		esac
		if [[ $is_closing == $true ]]; then
			if [[ "$b" == "$c_reverse" ]]; then
				unset 'b[0]'
				b=( "${b[@]}" )
				unset 'l[0]'
				l=( "${l[@]}" )
			else
				echo "stack:${b[@]}"
				echo "line:$c"
				echo "lines:${l[@]}"
				echo "error in line $line or in line $l"
				((l++))

				nl -ba "$1" | \
				sed -e 's/^.\{6\}/\0|/g' | \
				head -$line | \
				tail -$(($line-$l+2))

				ret=99
				break
			fi
		fi
		[[ $c == "==" ]] && \
			((line++))
	done

	nl -ba "$1" | sed -e 's/^.\{6\}/\0|/g'
	exit $ret
}

# parsing flags
case $1 in #(((
	'--help')	prog_help;;
	'--version')	prog_vers;;
	'--check')	prog_check_brackets "$0";;
esac

while getopts '::hVvna:t:' flag
do
	case $flag in #((((((((
		v)	verbose=$true;;
		h)	prog_help;;
		V)	prog_vers;;
		n)	nocolor=$true;;
		a)	fake_art="${OPTARG}";;
		t)	truncate="${OPTARG}";;
		*)	error "Please check your arguments. see: --help"
			exit 1
		;;
	esac
done
verb 'parsing flags... done.'

# color helper function, prints just the escape sequence
#
function code_to_color(){
	[[ $nocolor == $false ]] && \
		printf '\e[%sm' "$@" #]
}

# color vars
C_RESET=`	code_to_color '0'`
C_BOLD=`	code_to_color '1'`
C_UNDERLINE=`	code_to_color '4'`
C_REVERSE=`	code_to_color '7'`

C_BLACK=`	code_to_color '0;30'`
C_B_BLACK=`	code_to_color '0;40'`

C_DARK_GREY=`	code_to_color '0;1;30'`
C_B_DARK_GREY=`	code_to_color '0;1;40'`

C_RED=`		code_to_color '0;31'`
C_L_RED=`	code_to_color '0;1;31'`
C_B_RED=`	code_to_color '0;41'`
C_BL_RED=`	code_to_color '0;1;41'`

C_GREEN=`	code_to_color '0;32'`
C_L_GREEN=`	code_to_color '0;1;32'`
C_B_GREEN=`	code_to_color '0;42'`
C_BL_GREEN=`	code_to_color '0;1;42'`

C_BROWN=`	code_to_color '0;33'`
C_B_BROWN=`	code_to_color '0;43'`

C_YELLOW=`	code_to_color '0;1;33'`
C_B_YELLOW=`	code_to_color '0;1;43'`

C_BLUE=`	code_to_color '0;34'`
C_L_BLUE=`	code_to_color '0;1;34'`
C_B_BLUE=`	code_to_color '0;44'`
C_BL_BLUE=`	code_to_color '0;1;44'`

C_PURPLE=`	code_to_color '0;35'`
C_L_PURPLE=`	code_to_color '0;1;35'`
C_B_PURPLE=`	code_to_color '0;45'`
C_BL_PURPLE=`	code_to_color '0;1;45'`

C_CYAN=`	code_to_color '0;36'`
C_L_CYAN=`	code_to_color '0;1;36'`
C_B_CYAN=`	code_to_color '0;46'`
C_BL_CYAN=`	code_to_color '0;1;46'`

C_L_GREY=`	code_to_color '0;37'`
C_BL_GREY=`	code_to_color '0;47'`

C_WHITE=`	code_to_color '0;1;37'`
C_B_WHITE=`	code_to_color '0;1;47'`

# output function
function display(){
	for i in ${!ascii[@]}; do
		echo -e "$color_base${ascii[i]}$C_RESET$this_pad${output_text[0]}$C_RESET"
		unset 'output_text[0]'
		output_text=( "${output_text[@]}" )
	done
	for i in ${!output_text[@]}; do
		echo -e "$pad${output_text[0]}$C_RESET"
		unset 'output_text[0]'
		output_text=( "${output_text[@]}" )
	done
}

# function to add text on the right
function output_add_raw(){
	local add="$@"
	[[ "$truncate" -ne 0 ]] && \ # TODO truncate string
		add="${add}$C_RESET"

	output_text=( "${output_text[@]}" "$add" )
}

# function to add text on thr right with colored label
function output_add(){
	[[ -n "$2" && "$2" != "$unknown" ]] && \
	output_add_raw "$color_label$1$C_RESET: $2"
}

# functions where we set the width of logo
function get_len_from(){
	local width=${#ascii[$1]}
	get_len_set $width
}
function get_len_set(){
	pad=""
	i=0
	while [[ $i -lt $1 ]]; do
		pad="$pad "
		((i++))
	done
	verb "setting pad as: -$pad-"
}

# tux the penguin as a function
function source_ascii(){
	[[ "$fake_art" != "$unknown" ]] && \
		local distro="$fake_art"

	local distro_lower="$(
		sed -e 's/ /_/g;s/-/_/g' <<< "$distro" | \
		tr '[:upper:]' '[:lower:]'
	)"

	local art_file="$(
		dirname $0
	)/logo/$distro_lower.sh"
	
	if [[ -f "$art_file" ]]; then
		source "$art_file"
	else
		error "logo of $distro not found ($art_file), using tux"

		local c1=$C_WHITE
		local c2=$C_YELLOW

		color_base=$C_DARK_GREY
		color_label=$C_YELLOW
		ascii=( #the space here is required (vim)
			"                       "
			"         #####         "
			"        #######        "
			"        ##${c1}O${color_base}#${c1}O${color_base}##        "
			"        #${c2}#####${color_base}#        "
			"      ##${c1}##${c2}###${c1}##${color_base}##      "
			"     ##${c1}#########${color_base}##     "
			"    ##${c1}###########${color_base}##    "
			"   ###${c1}###########${color_base}###   "
			"${c2}   ##${color_base}#${c1}###########${color_base}#${c2}##   "
			"${c2} ######${color_base}#${c1}#######${color_base}#${c2}###### "
			"${c2} #######${color_base}#${c1}#####${color_base}#${c2}####### "
			"${c2}   #####${color_base}#######${c2}#####   "
			"                       "
		)

		get_len_from 0
		#get_len_set 42
	fi
}

# the distro detection
function detect_distribution(){
	distro="$unknown"
	distro_more=""
	ascii=()
	pkg_cmd=""

	color_label=$C_RESET

	[[ -d /etc/portage ]] && {
		distro="Gentoo"
		pkg_cmd='ls -d /var/db/pkg/*/* | wc -l'
		color_label=$C_L_PURPLE
	}

	[[ -d /etc/pacman.d ]] && {
		distro="Arch Linux"
		pkg_cmd='pacman -Qq | wc -l'
		color_label=$C_L_CYAN
	}

	[[ -f /system/build.prop ]] && {
		distro="Android"
		distro_more="$(
			getprop ro.build.version.release
		) @ $(
			getprop ro.product.nickname
		) ($(
			getprop ro.product.model
		) $(
			getprop ro.product.device
		))"
		color_label=$C_L_GREEN
	}

	[[ -f /etc/satellite ]] && {
		distro="Satellite Linux"
	}

	# TODO add distros
	[[ -f /etc/tumbleweed ]] && {
		distro="openSUSE"
		distro_more="Tumbleweed"
		pkg_cmd='rpm -qa | wc -l'
		color_label=$C_L_GREEN
	}

	[[ -f /etc/raspbian ]] && {
		distro="Raspbian"
		distro_more="version..."
		pkg_cmd='dpkg -l | grep -c "^i"'
		color_label=$C_L_RED
	}

	verb "print_distribution='$distro $distro_more',"
	verb "\-> '$pkg_cmd'"
}

# all print_* functions
function print_distribution(){
	output_add "OS" "$distro $distro_more"
}

function print_user_hostname(){
	local user="${USER}"
	[[ -z "${USER}" ]] && \
		user="$(whoami)"
	local host=${HOSTNAME}

	verb "print_user_hostname='$user@$host'"
	output_add_raw "$user$color_label@$C_RESET$host"
}

function print_kernel_version(){
	local arch="$(
		uname -m
	)"
	local type="$(
		uname -s
	)"
	local version="$(
		uname -r
	)"
	local kernel="$type $version @ $arch"

	verb "print_kernel_version='$kernel'"
	output_add "Kernel" "$kernel"
}

function print_uptime(){
	local uptime="$unknown"
	if [[ -f /proc/uptime ]]; then
		uptime=$(</proc/uptime)
		uptime=${uptime//.*}

		[[ "${uptime}" != "$unknown" ]] && {
			local m=$((uptime/60%60))
			local h=$((uptime/3600%24))
			local d=$((uptime/86400))
			uptime="${mins}m"
			[[ "${h}" -ne "0" ]] && \
				uptime="${h}h ${uptime}"
			[[ "${d}" -ne "0" ]] && \
				uptime="${d}d ${uptime}"
		}
	else
		uptime="$(
			{
				uptime 2>/dev/null | \
				sed -e 's/  /\n/g' | \
				sed -e '
					1!d;
					s/,$//g;
					s/[ ]\+//;
					s/^..:..:..//;
					s/ up //'
			} || \
			echo $unknown
		)"
	fi

	verb "print_uptime='$uptime'"
	output_add "Uptime" "$uptime"
}

function print_package_count(){
	local pkgs="$unknown"
	pkgs=$(eval $pkg_cmd)

	verb "print_package_count='$pkgs'"
	output_add "Packages" "$pkgs"
}

function print_cpu(){ # TODO make readable!!!!!! XXX
	local REGEXP="-r"
	local name="$(
		awk -F':' '
			/^model name/{
				split($2, A, " @");
				print $2;
				exit;
			}
		' /proc/cpuinfo
	)"

	local number="$(
		grep -c '^processor' /proc/cpuinfo
	)x "
	[[ "$number" == "1x " ]] && \
		number=''

	local smf="/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
	local freq=""
	local freq_suffix="MHz"

	[[ -f "$smf" && -r "$smf" ]] && \
		freq="$(($(<$smf) / 1000))"

	if [[ "$freq" != "" ]]; then
		if [[ "${freq%.*}" -ge 1000 ]]; then
			freq="$(awk '{print $1/1000}' <<< "$freq")"
			freq_suffix="GHz"
		fi

		freq=" @ ${freq}${freq_suffix}"
	fi

	# get the cpu temperature
	if [ -d '/sys/class/hwmon/' ]; then
		for dir in /sys/class/hwmon/* ; do
			hwmonfile=""
			[[ -e "$dir/name" ]] && \
				hwmonfile=$dir/name
			[[ -e "$dir/device/name" ]] && \
				hwmonfile=$dir/device/name
			if [[ -n "$hwmonfile" ]] && grep -q 'coretemp' "$hwmonfile"; then
				thermal="$dir/temp1_input"
				break
			fi
		done
		# ${name:+string} results:
		# if name is unset/null = nothing
		# else string
		[[ -e "$thermal" ]] && \
		[[ "${thermal:+!null}" == '!null' ]] && \
			temperature=$(($(cat "$thermal")/1000))
	fi
	cpu="${number}${name}${freq}"
	[[ -n "$temperature" ]] && \
		cpu="$cpu [${temperature}°C]"
	cpu=$(sed $REGEXP 's/\([tT][mM]\)|\([Rr]\)|[pP]rocessor|CPU//g' <<< "${cpu}")
	sed $REGEXP 's/\([tT][mM]\)|\([Rr]\)|[pP]rocessor|CPU//g' <<< "${cpu}" | cat
	sed $REGEXP 's/\([tT][mM]\)|\([Rr]\)|[pP]rocessor|CPU//g' <<< "${cpu}" | xargs

	verb "TODO Finding current CPU...found as '$cpu'"
	output_add "CPU" "$cpu"
}

function print_gpu(){ # TODO make readable!!!!!! XXX
	if [[ -n "$(PATH="/opt/bin:$PATH" type -p nvidia-smi)" ]]; then
		gpu=$($(PATH="/opt/bin:$PATH" type -p nvidia-smi | cut -f1) -q | awk -F':' '/Product Name/ {gsub(/: /,":"); print $2}' | sed ':a;N;$!ba;s/\n/, /g')
	elif [[ -n "$(PATH="/usr/sbin:$PATH" type -p glxinfo)" && -z "${gpu}" ]]; then
		gpu_info=$($(PATH="/usr/sbin:$PATH" type -p glxinfo | cut -f1) 2>/dev/null)
		gpu=$(grep "OpenGL renderer string" <<< "${gpu_info}" | cut -d ':' -f2 | sed -n -e '1h;2,$H;${g;s/\n/, /g' -e 'p' -e '}')
		gpu="${gpu:1}"
		gpu_info=$(grep "OpenGL vendor string" <<< "${gpu_info}")
	elif [[ -n "$(PATH="/usr/sbin:$PATH" type -p lspci)" && -z "$gpu" ]]; then
		gpu_info=$($(PATH="/usr/bin:$PATH" type -p lspci | cut -f1) 2> /dev/null | grep VGA)
		gpu=$(grep -oE '\[.*\]' <<< "${gpu_info}" | sed 's/\[//;s/\]//' | sed -n -e '1h;2,$H;${g;s/\n/, /g' -e 'p' -e '}')
	fi

	if [ -n "$gpu" ];then
		if grep -q -i 'nvidia' <<< "${gpu_info}"; then
			gpu_info="NVidia "
		elif grep -q -i 'intel' <<< "${gpu_info}"; then
			gpu_info="Intel "
		elif grep -q -i 'amd' <<< "${gpu_info}"; then
			gpu_info="AMD "
		elif grep -q -i 'ati' <<< "${gpu_info}" || grep -q -i 'radeon' <<< "${gpu_info}"; then
			gpu_info="ATI "
		else
			gpu_info=$(cut -d ':' -f2 <<< "${gpu_info}")
			gpu_info="${gpu_info:1} "
		fi
		gpu="${gpu}"
	else
		gpu="$unknown"
	fi

	verb "TODO Finding current GPU...found as '$gpu'"
	output_add "GPU" "$gpu"
}

# Detect Intel GPU  #works in dash
# Run it only on Intel Processors if GPU is unknown
function DetectIntelGPU(){ # TODO make readable!!!!!! XXX
	if [ -r /proc/fb ]; then
		gpu=$(awk 'BEGIN {ORS = " &"} {$1="";print}' /proc/fb | sed  -r s/'^\s+|\s*&$'//g)
	fi

	case $gpu in #(((
		*mfb)
			gpu=$(lspci | grep -i vga | awk -F ": " '{print $2}') 
			;;
		*intel*)
			gpu="intel"
			;;
		*)
			gpu="$unknown"
			;;
	esac

	if [[ "$gpu" = "intel" ]]; then
		#Detect CPU
		local CPU=$(uname -p | awk '{print $3}')
		CPU=${CPU#*'-'}; #Detect CPU number

		#Detect Intel GPU
		case $CPU in #((((((((
			[3-6][3-9][0-5]|[3-6][3-9][0-5][K-Y])
				gpu='Intel HD Graphics'
				;; #1st
			2[1-5][0-3][0-2]*|2390T|2600S)
				gpu='Intel HD Graphics 2000'
				;; #2nd
			2[1-5][1-7][0-8]*|2105|2500K)
				gpu='Intel HD Graphics 3000'
				;; #2nd
			32[1-5]0*|3[4-5][5-7]0*|33[3-4]0*)
				gpu='Intel HD Graphics 2500'
				;; #3rd
			3570K|3427U)
				gpu='Intel HD Graphics 4000'
				;; #3rd
			4[3-7][0-9][0-5]*)
				gpu='Intel HD Graphics 4600'
				;; #4th Haswell
			5[5-6]75[C-R]|5350H)
				gpu='Intel Iris Pro Graphics 6200'
				;; #5th Broadwell
				#6th Skylake
				#7th Kabylake
				#8th Cannonlake
			*)
				gpu="$unknown"
				;; #Unknown GPU model
		esac
	fi
}

function print_disk_usage(){
	local diskusage="$unknown"
	type -p df >/dev/null 2>&1 && \
	diskusage="$(
		awk '{print $3" / "$2" ("$5")"}' \
		<<< "$(
			df -h \
				-x aufs \
				-x tmpfs \
				-x overlay \
				--total 2>/dev/null | \
			tail -1
		)"
	)"
	verb "print_disk_usage='$diskusage'"
	output_add "Disk Usage" "$diskusage"
}

function print_mem(){
	local memusage="$(
		free -b | \
		awk 'NR==2{
			total=int($2 / 1024 / 1024);
			used=int(($2 - $7) / 1024 / 1024);
			print used"MiB / "total"MiB";;
		}'
	)"
	verb "print_mem='$memusage'"
	output_add "RAM" "$memusage"
}

function print_shell(){
	local shell_name="bash"
	local shell_version="$(
		$shell_name --version | \
		awk '/^GNU/{
			gsub(/\([0-9]+\)-[a-z]+/, "", $4);
			print $4;
		}'
	)"

	local shell="$shell_name $shell_version"

	verb "print_shell='$shell'"
	output_add "Shell" "$shell"
}

# let's do this!
detect_distribution

source_ascii

all_to_print

display

exit 0

# get the content of brace expansion
#PAGER='cat' man bash | \
#	tail -n +1396 | \
#	head -448 | \
#	cat -v | \
#	sed -e 's/.\^H//g' > bash_braces.txt

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
