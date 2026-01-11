#!/bin/bash

set -e

# Wait for sway/network stuff
sleep 2

# Mount filesystems
mount -a

apps=( owncloud vesktop swaync rancher-desktop keepassxc )

for app in "${apps[@]}"; do
    if command -v "$app" &> /dev/null; then
        swaymsg "exec --no-startup-id $app" || logger "Failed to launch $app"
        sleep 0.5
    else
        logger "Warning: $app not found in PATH"
    fi
done