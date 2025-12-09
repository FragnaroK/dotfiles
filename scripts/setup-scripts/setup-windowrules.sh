#!/usr/bin/env bash

#-------------------------------------------------------------
# Switch between Desktop and Laptop window rules
#-------------------------------------------------------------

set -euo pipefail

CUSTOM_CONFIG_PATH="$HOME/.config/hypr/conf/windowrules/custom"
WINDOWRULES_CONFIG_PATH="$HOME/.config/hypr/conf/windowrules/custom.conf" 

selected_env="$1"

toggle_config() {
    local source_path="$CUSTOM_CONFIG_PATH/windowrules-$1.conf"

    cp -fv "$source_path" "$WINDOWRULES_CONFIG_PATH"

    if [ $? -ne 0 ]; then
        echo "Error: Could not set $1 window rules"
        # notify-send --urgency=critical "Environment Setup" "Could not set $1 window rules"
        exit 1
    fi

    echo "Monitors config set to $1 window rules"
    # notify-send "Environment Setup" "Window rules config set to $1 "
}

if [[ "$selected_env" == "desktop" ]] || [[ "$selected_env" == "laptop" ]]; then
    toggle_config "$selected_env"
else
    echo "Error: Window rules $selected_env not implemented"
    # notify-send "Environment Setup" "Window rules $selected_env not implemented"
    exit 1
fi
 
exit 0