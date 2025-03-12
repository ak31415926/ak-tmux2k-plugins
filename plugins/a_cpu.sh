#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/a_utils.sh"

get_percent() {
    case $(uname -s) in
    Linux)
        percent=$(LC_ALL=C top -bn2 -d 0.01 | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | LC_ALL=C awk '{print 100 - $1}')
        echo -n "$percent"
        ;;

    Darwin)
        cpuvalue=$(ps -A -o %cpu | awk -F. '{s+=$1} END {print s}')
        cpucores=$(sysctl -n hw.logicalcpu)
        cpuusage=$((cpuvalue / cpucores))
        percent="$cpuusage%"
        echo -n "$percent"
        ;;

    CYGWIN* | MINGW32* | MSYS* | MINGW*) ;; # TODO - windows compatibility
    esac
}

get_load() {
    case $(uname -s) in
    Linux | Darwin)
        loadavg=$(LC_ALL=C uptime | awk -F'[a-z]: ' '{ print $2}' | sed 's/,//g')
        echo -n "$loadavg"
        ;;

    CYGWIN* | MINGW32* | MSYS* | MINGW*) ;; # TODO - windows compatibility
    esac
}

main() {
	fs=$(get_tmux_option "@tmux2k-a_cpu-format-string" " #4[#o%#]")
	user_locale=$(get_tmux_option "@tmux2k-user-locale" "en_US.UTF-8")

    export LC_ALL="$user_locale"

    cpu_load=$(get_load)
    cpu_load=$(number2locale "\"$cpu_load\"" $user_locale)
    cpu_percent=$(get_percent)
    cpu_percent=$(number2locale $cpu_percent $user_locale)
    cpu_opercent=$(round "$cpu_percent" "0")
    if [ "$cpu_opercent" -lt "10" ]; then
        cpu_opercent="$cpu_percent"
    fi
	fs=$(fill_placeholders "$fs" "p" "f" "$cpu_percent")
	fs=$(fill_placeholders "$fs" "P" "g" "$cpu_percent")
	fs=$(fill_placeholders "$fs" "o" "g" "$cpu_opercent")
	fs=$(fill_placeholders "$fs" "L" "s" "$cpu_load")

	fs=$(normalize_brackets "$fs")

    echo -n "$fs"
}

main
