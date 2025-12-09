#!/usr/bin/bash

set -euo pipefail

if [ ! -d "$HOME/.config/hypr/external/SilentSDDM" ]; then
    echo "SilentSDDM theme not found. Please run the setup script first."
    exit 1
fi

sudo cp -rf "$HOME/.config/hypr/external/SilentSDDM" /usr/share/sddm/themes/silent/