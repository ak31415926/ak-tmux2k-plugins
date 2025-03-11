#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux bind-key S run-shell "$CURRENT_DIR/scripts/install.sh"

declare -A plugin_colors=(
    ["a_uptime"]="light_blue text"
)

main() {
	for plugin in "${!plugin_colors[@]}"; do
		tmux set-option -g @tmux2k-${plugin}-colors "${plugin_colors[$plugin]}"
    done
	plugin_path="$(tmux show-env -g TMUX_PLUGIN_MANAGER_PATH | cut -f2 -d=)"
	./${plugin_path}/tmux2k/2k.tmux
}

main
