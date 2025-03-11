#!/usr/bin/env bash

# fetching the directory where plugins are installed
plugin_path="$(tmux show-env -g TMUX_PLUGIN_MANAGER_PATH | cut -f2 -d=)"
tmux2k_path="${plugin_path}tmux2k"
ak_plugins_path="${plugin_path}ak-tmux2k-plugins"

exit() {
	echo "Press ESC to continue"
	builtin exit $1
}

# listing installed plugins
if [ -d "$tmux2k_path" ]; then 
	echo "tmux2k found in $tmux2k_path"
else
	echo "tmux2k NOT found in $tmux2k_path"
	exit
fi

if [ -d "$ak_plugins_path" ]; then 
	echo "ak-tmux2k-plugins found in $ak_plugins_path"
else
	echo "ak-tmux2k-plugins NOT found in $ak_plugins_path"
	exit
fi

echo "Making symbolic links"

for f in `ls ${ak_plugins_path}/plugins`; do
#	echo "plugins/$f"
	ln -is ${ak_plugins_path}/plugins/${f} ${tmux2k_path}/plugins/${f}
done

for f in `ls ${ak_plugins_path}/lib`; do
	ln -is ${ak_plugins_path}/lib/${f} ${tmux2k_path}/lib/${f}
done

echo "Done"

exit 0
