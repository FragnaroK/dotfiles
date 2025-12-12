#!/usr/bin/env bash

#-------------------------------------------------------------
# Switch between Desktop and Laptop monitor/workspace configs
#-------------------------------------------------------------

set -euo pipefail

CUSTOM_CONFIG_PATH="$HOME/.config/hypr/monitors"
MONITOR_CONFIG_PATH="$HOME/.config/hypr/monitors.conf"
WORKSPACES_CONFIG_PATH="$HOME/.config/hypr/workspaces.conf"

selected_env="$1"

toggle_config() {
    local source_monitors_path="$CUSTOM_CONFIG_PATH/monitors-$1.conf"
    local source_workspaces_path="$CUSTOM_CONFIG_PATH/workspaces-$1.conf"

    cp -fv "$source_monitors_path" "$MONITOR_CONFIG_PATH"
    cp -fv "$source_workspaces_path" "$WORKSPACES_CONFIG_PATH"

    if [ $? -ne 0 ]; then
        echo "Error: Could not set $1 mode"
        # notify-send --urgency=critical "Environment Setup" "Could not set $1 mode"
        exit 1
    fi

    echo "Monitors config set to $1 mode"
    # notify-send "Environment Setup" "Monitors config set to $1 mode"
}

if [[ "$selected_env" == "desktop" ]] || [[ "$selected_env" == "laptop" ]]; then
    toggle_config "$selected_env"
else
    echo "Error: Option $selected_env not implemented"
    # notify-send "Environment Setup" "Option $selected_env not implemented"
    exit 1
fi
 
exit 0