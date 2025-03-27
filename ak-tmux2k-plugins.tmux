#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
KEY_BINDING_REGEX="bind-key[[:space:]]\+\(-r[[:space:]]\+\)\?\(-T prefix[[:space:]]\+\)\?"

declare -A plugin_colors=(
    ["a_cpu"]="light_green text"
    ["a_cpu_temp"]="light_purple text"
    ["a_ram"]="yellow text"
    ["a_uptime"]="light_blue text"
)

key_binding_not_set() {
    local key="${1//\\/\\\\}"
    if $(tmux list-keys | grep -q "${KEY_BINDING_REGEX}${key}[[:space:]]"); then
        return 1
    else
        return 0
    fi
}


main() {
    local user_locale=`tmux show-option -v -g @tmux2k-user-locale`
    if [ "$user_locale" = "" ]; then
        tmux set-option -g @tmux2k-user-locale "$LANG"
    fi
	for plugin in "${!plugin_colors[@]}"; do
		tmux set-option -g @tmux2k-${plugin}-colors "${plugin_colors[$plugin]}"
    done

    local install_key_bind=$(tmux show-option -gv @tmux2k-akplugins-install-key-binding)

    if [ -n "$install_key_bind" ]; then
        tmux bind-key "$install_key_bind" run-shell "$CURRENT_DIR/scripts/install.sh"
    else
        if key_binding_not_set "S"; then
            tmux bind-key S run-shell "$CURRENT_DIR/scripts/install.sh"
        fi
    fi
    
    plugin_path="$(tmux show-env -g TMUX_PLUGIN_MANAGER_PATH | cut -f2 -d=)"
	source ${plugin_path}/tmux2k/2k.tmux
}

main
