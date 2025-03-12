#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/a_utils.sh"

get_cpu_temp() {
	case $(uname -s) in
	Linux)
		temperature=$(LC_ALL=C sensors | grep -oP 'Tctl:.*?\+\K[0-9.]+')
		;;

	Darwin)
		temperature=$(ioreg -r -n "AppleSmartBattery" | grep -i "Temperature" | awk '{print $3/100}')
		;;

	CYGWIN* | MINGW32* | MSYS* | MINGW*) ;; # TODO - windows compatibility
	esac
	echo -n "$temperature"
}

round() {
	printf "%.${2}f" "${1}"
}

main() {
	fs=$(get_tmux_option "@tmux2k-a_cpu_temp-format-string" " #2.1t")
	user_locale=$(get_tmux_option "@tmux2k-user-locale" "en_US.UTF-8")
    export LC_ALL="$user_locale"

	cpu_temp=$(get_cpu_temp)
	cpu_temp=$(number2locale $cpu_temp $user_locale)

  	fs=$(fill_placeholders "$fs" "t" "f" "$cpu_temp")
	fs=$(normalize_brackets "$fs")

    echo -n "$fs"
}

main
