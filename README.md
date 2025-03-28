# Additional Set of Plugins for tmux2k

The main goal of these plugins is to provide more control over the content of the tmux status bar. These plugins are intended to work in the [tmux2k](https://github.com/2KAbhishek/tmux2k) environment.

## Features
- **Control**: All efforts are made to provide control over every single space character.
- **Flexible Configuration**: Plugins from this repository provide a powerful and uniform method of configuration using format strings.
- **Localization**: Special attention is paid to localization, including the use of localized utilities.

## Installation
### With Tmux Plugin Manager (Recomended)

Installation with [TPM](https://github.com/tmux-plugins/tpm) consists of two steps.

First, you need to install the `ak-tmux2k-plugins` plugin as a TPM plugin.
To do this, you should add the plugin to the list of TPM plugins in your `.tmux.conf` file.

    set -g @plugin 'ak31415926/ak-tmux2k-plugins'

Hit `prefix + I` to fetch the plugin and source it.

On second stage you need to connect `ak-tmux2k-plugins` to `tmux2k` enviroment.

To do this, hit `prefix+S`.

> **Note**:
>
If you have already bound the S key to another function you will need to redefine the key binding using the `@tmux2k-ak-plugins-install-key-binding` variable.  If the key is not rebinded, it will default to its original function.

### Manual

You can clone the repository to any directory. Next, you need to copy the contents of the `plugins` directory into the `plugins` folder of the [tmux2k](https://github.com/2KAbhishek/tmux2k) installation, and the contents of the `lib` directory into the corresponding `lib` folder.

The last step is to copy the `plugin_colors` array content from the `ak-tmux2k-plugins.tmux` file into the corresponding array in the `main.sh` file in the [tmux2k](https://github.com/2KAbhishek/tmux2k) installation. Alternatively, you can manually set the colors for each plugin.

## Configuration
---

### Global

### Format Strings

#### Placers

#### Format Specifiers

#### Brackets

## Available Plugins
---
### 1. `a_cpu`

Show CPU usage information

#### Format string

- `tmux2k-cpu-icon`: Icon for CPU usage, default: ``
- `tmux2k-cpu-display-load`: Control CPU load display, default: `false`

### 2. `a_cpu_temp`

Show CPU temperature

#### Format string

### 3. `a_ram`

Show RAM usage information

#### Format string

### 4. `a_uptime`

Show current system uptime

#### Format string