#!/bin/bash
set -euo pipefail

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root" >&2
   exit 1
fi

# Check if brave-browser is already installed
if command -v brave-browser >/dev/null 2>&1; then
    echo "[INFO] Brave browser is already installed ($(brave-browser --version))"
    exit 0
fi

echo "[INFO] Brave browser not found. Installing..."

# Download and install Brave GPG key
echo "[INFO] Adding Brave repository GPG key..."
if ! curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
    -o /usr/share/keyrings/brave-browser-archive-keyring.gpg; then
    
    echo "[ERROR] Failed to download GPG key" >&2
    exit 1
fi

# Add Brave repository sources
echo "[INFO] Adding Brave repository."
if ! curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser.sources \
    -o /etc/apt/sources.list.d/brave-browser-release.sources; then
    echo "[ERROR] Failed to download repository sources" >&2
    exit 1
fi

# Update package list and install Brave
echo "[INFO] Installing Brave browser."

apt-get update -qq
if ! apt-get install -y brave-browser; then
    echo "[ERROR] Failed to install Brave browser" >&2
    exit 1
fi

echo "[INFO] Brave browser installation complete!"
brave-browser --version