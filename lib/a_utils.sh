#!/usr/bin/env bash

round() {                                                                                                                                                           
    printf "%.${2}f" "${1}"                                                                                                                                         
} 

get_decimal_point() {
# Usage: get_decimal_point locale
    local decimal_point="."
    export LC_ALL="$1"
	printf -v decimal_point "%.1f" "1"
    echo -n "${decimal_point:1:1}"
}

get_tmux_option() {
    local option=$1
    local default_value=$2
    local option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo $default_value
    else
        echo $option_value
    fi
}

normalize_padding() {
    local percent_len=${#1}
    local max_len=${2:-4}
    local left_spaces=0
    local right_spaces=0
    let diff_len=$max_len-$percent_len
    # if the diff_len is even, left will have 1 more space than right
    let left_spaces=($diff_len + 1)/2
    let right_spaces=($diff_len)/2
    printf "%${left_spaces}s%s%${right_spaces}s\n" "" $1 ""
}

fill_placeholders() {
# Usage: fill_placeholders formatstring placeholder type value
	local result=$1
	while [[ "$result" =~ \#(.?[[:digit:]]*\.?[[:digit:]]*)(${2}) ]];
	do
		tfs="%${BASH_REMATCH[1]}$3"
		printf -v val "${tfs}" "$4"
		result=${result//${BASH_REMATCH[0]}/$val}
	done
	result=${result//\#${2}/"${4}"}
	echo -n "$result"
}

normalize_brackets() {
# Usage: fill_placeholders formatstring
	local result=$1
	while [[ "$result" =~ \#([1-9][0-9]*)\[([^\]]*)\#\] ]];
	do
		content="$(normalize_padding ${BASH_REMATCH[2]} ${BASH_REMATCH[1]})"
		result=${result/"${BASH_REMATCH[0]}"/$content}
	done
	echo -n "$result"
}

