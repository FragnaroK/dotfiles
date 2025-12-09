#!/usr/bin/env bash

#-------------------------------------------------------------
# Switch between Desktop and Laptop window rules
#-------------------------------------------------------------

set -euo pipefail

CUSTOM_CONFIG_PATH="$HOME/.config/hypr/conf/layouts/custom"
LAYOUTS_CONFIG_PATH="$HOME/.config/hypr/conf/layouts/custom.conf" 

selected_env="$1"

toggle_config() {
    local source_path="$CUSTOM_CONFIG_PATH/layouts-$1.conf"

    cp -fv "$source_path" "$LAYOUTS_CONFIG_PATH"

    if [ $? -ne 0 ]; then
        echo "Error: Could not set $1 layouts"
        # notify-send --urgency=critical "Environment Setup" "Could not set $1 layouts"
        exit 1
    fi

    echo "Monitors config set to $1 layouts"
    # notify-send "Environment Setup" "layouts config set to $1 "
}

if [[ "$selected_env" == "desktop" ]] || [[ "$selected_env" == "laptop" ]]; then
    toggle_config "$selected_env"
else
    echo "Error: layouts $selected_env not implemented"
    # notify-send "Environment Setup" "layouts $selected_env not implemented"
    exit 1
fi
 
exit 0