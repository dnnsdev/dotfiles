#!/bin/bash

set -e

DEB_FILE="vesktop.deb"

# Function to clean up
cleanup() {
    if [[ -f "$DEB_FILE" ]]; then
        echo "[INFO] Cleaning up $DEB_FILE."
        rm -f "$DEB_FILE"
    fi
}

# Ensure cleanup on exit
trap cleanup EXIT

# Download the latest vesktop .deb file
echo "[INFO] Downloading latest Vesktop package."
wget https://vencord.dev/download/vesktop/amd64/deb -O "$DEB_FILE"

# Extract version from the downloaded .deb file
DEB_VERSION=$(dpkg-deb -f "$DEB_FILE" Version)
echo "[INFO] Downloaded version: $DEB_VERSION"

# Check if vesktop is already installed
if command -v vesktop >/dev/null 2>&1; then
    # Get currently installed version
    INSTALLED_VERSION=$(dpkg -l | grep vesktop | awk '{print $3}')
    echo "[INFO] Installed version: $INSTALLED_VERSION"
    
    # Compare versions
    if dpkg --compare-versions "$DEB_VERSION" gt "$INSTALLED_VERSION"; then
        echo "[INFO] Newer version available. Installing Vesktop $DEB_VERSION."
        dpkg -i "$DEB_FILE"
        echo "[INFO] Vesktop updated successfully!"
    else
        echo "[INFO] Vesktop is already up to date (version $INSTALLED_VERSION)"
    fi
else
    # Vesktop not installed, install it
    echo "[INFO] Vesktop not found. Installing version $DEB_VERSION."
    dpkg -i "$DEB_FILE"
    echo "[INFO] Vesktop installed successfully!"
fi