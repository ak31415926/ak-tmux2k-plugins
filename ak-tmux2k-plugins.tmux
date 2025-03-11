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
}

main
