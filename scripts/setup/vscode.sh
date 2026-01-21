#!/bin/bash

set -e

GPG_FILE="packages.microsoft.gpg"

# Function to clean up
cleanup() {
    if [[ -f "$GPG_FILE" ]]; then
        echo "[INFO] Cleaning up $GPG_FILE."
        rm -f "$GPG_FILE"
    fi
}

# Ensure cleanup on exit
trap cleanup EXIT

if command -v code >/dev/null 2>&1; then
  echo "[INFO] Visual Studio Code (code) is already installed."
else
  echo "[INFO] Installing Visual Studio Code."
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > "$GPG_FILE"
  install -D -o root -g root -m 644 "$GPG_FILE" /etc/apt/keyrings/$GPG_FILE
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/$GPG_FILE] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null
fi