#!/usr/bin/env bash

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
    percent_len=${#1}
    max_len=${2:-4}
    let diff_len=$max_len-$percent_len
    # if the diff_len is even, left will have 1 more space than right
    let left_spaces=($diff_len + 1)/2
    let right_spaces=($diff_len)/2
    printf "%${left_spaces}s%s%${right_spaces}s\n" "" $1 ""
}

fill_placeholders() {
# Usage: fill_placeholders formatstring placeholder type value
	result=$1
	while [[ "$result" =~ \#(.?[[:digit:]]*\.?[[:digit:]]+)(${2}) ]];
	do
		tfs="%${BASH_REMATCH[1]}$3"
		printf -v val ${tfs} $4
		result=${result//${BASH_REMATCH[0]}/$val}
	done
	result=${result//\#${2}/${4}}
	echo -n "$result"
}

normalize_brackets() {
# Usage: fill_placeholders formatstring
	result=$1
	while [[ "$result" =~ \#([1-9][0-9]*)\[([^\]]*)\#\] ]];
	do
		content="$(normalize_padding ${BASH_REMATCH[2]} ${BASH_REMATCH[1]})"
		result=${result/"${BASH_REMATCH[0]}"/$content}
	done
	echo -n "$result"
}
