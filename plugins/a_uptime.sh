#!/usr/bin/env bash

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/../lib/a_utils.sh"

export LC_ALL="en_US.UTF-8"

get_uptime() {
    uptime -p | awk '
    {
        for(i=1;i<NF;i++) {
        	if($(i) ~ /^[0-9]+$/ && $(i+1) ~ /^day/) d=$(i)
            if($(i) ~ /^[0-9]+$/ && $(i+1) ~ /^hour/) h=$(i)
            if($(i) ~ /^[0-9]+$/ && $(i+1) ~ /^min/) m=$(i)
        }
        printf "%s:%s:%d:%d:%d:%f:%f:%f\n", \
            (d?d:""), (h?h:""), (m?m:0), \
			(d?d:0)*24+(h?h:0), ((d?d:0)*24+(h?h:0))*60+(m?m:0), \
			(d?d:0)+((h?h:0)*60+(m?m:0))/(24*60), \
			(h?h:0)+(m?m:0)/60, \
			(d?d:0)*24+(h?h:0)+(m?m:0)/60
    }'
}

main() {
	fs=$(get_tmux_option "@tmux2k-a_uptime-format-string" "󰀠 #D[#dd #02hh #02mm#D]#d[#H[#hh #02mm#H]#h[#2m min#h]#d]")
	user_locale=$(get_tmux_option "@tmux2k-user-locale" "en_US.UTF-8")
	export LC_ALL="$user_locale"

	t_ifs=$IFS
	IFS=":"
	read days hours minutes fullhours fullminutes fracdays frachours fracfullhours <<< $(get_uptime)
	IFS=$t_ifs

	if [ "$days" = "" ]; then
		fs=${fs//\#D\[*\#D\]/}
		fs=${fs//\#d\[/}
		fs=${fs//\#d\]/}
		days=0
	else
		fs=${fs//\#d\[*\#d\]/}
		fs=${fs//\#D\[/}
		fs=${fs//\#D\]/}
	fi
	if [ "$hours" = "" ]; then
		fs=${fs//\#H\[*\#H\]/} 
		fs=${fs//\#h\[/}
		fs=${fs//\#h\]/}
		hours=0
	else
		fs=${fs//\#h\[*\#h\]/}
		fs=${fs//\#H\[/}
		fs=${fs//\#H\]/}
	fi
	fs=$(fill_placeholders "$fs" "d" "d" $days)
	fs=$(fill_placeholders "$fs" "h" "d" $hours)
	fs=$(fill_placeholders "$fs" "m" "d" $minutes)
	fs=$(fill_placeholders "$fs" "H" "d" $fullhours)      # full hours (days*24+hours)
	fs=$(fill_placeholders "$fs" "M" "d" $fullminutes)    # full minutes ((days*24+hours)*60+minutes)
	fs=$(fill_placeholders "$fs" "D" "f" $fracdays)       # fractional days  days+((hours*60+minutes)/(24*60))
	fs=$(fill_placeholders "$fs" "F" "f" $fracfullhours)  # full fractional hours (full hours)+(minutes/60)
	fs=$(fill_placeholders "$fs" "f" "f" $frachours)      # fractional hours (hours)+(minutes/60)

	fs=$(normalize_brackets "$fs")

	echo -n "$fs"
}

main
