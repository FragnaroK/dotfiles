#!/usr/bin/bash
set -euo pipefail

# --- Constants ---
HYPR_CONFIG_PATH="$HOME/.config/hypr"
SDDM_THEME_PATH="$HOME/.config/hypr/external/SilentSDDM"

# --- Setup SDDM and Theme ---
sudo systemctl disable gdm || echo "GDM not installed"
sudo systemctl enable sddm || echo "SDDM installation failed"

mkdir -p "$SDDM_THEME_PATH"

git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM.git "$SDDM_THEME_PATH"
if [ $? -ne 0 ]; then
    echo "Failed to clone SilentSDDM repository."
    exit 1
fi

# Copy  assets
cp "$HYPR_CONFIG_PATH/assets"/* "$SDDM_THEME_PATH"/backgrounds/

# Apply custom SDDM theme configuration
cat "$HYPR_CONFIG_PATH/conf/sddm/metadata.desktop" > "$SDDM_THEME_PATH/metadata.desktop"
cat "$HYPR_CONFIG_PATH/conf/sddm/configs/default.conf" > "$SDDM_THEME_PATH/configs/default.conf"

# --- Apply SDDM theme ---
cd "$SDDM_THEME_PATH"

# Copy the theme to SDDM themes directory
sudo mkdir -p /usr/share/sddm/themes/silent
sudo cp -rf . /usr/share/sddm/themes/silent/

# Install fonts
sudo cp -r /usr/share/sddm/themes/silent/fonts/* /usr/share/fonts/
