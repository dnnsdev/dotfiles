#!/bin/bash

echo "[INFO] Checking if thorium-browser is installed..."

if ! command -v thorium >/dev/null 2>&1; then
  echo "[INFO] Thorium Browser not found. Downloading latest .deb package..."
  DEB_URL=$(curl -s https://api.github.com/repos/Alex313031/Thorium/releases/latest | grep browser_download_url | grep .deb | cut -d '"' -f 4)
  if [ -z "$DEB_URL" ]; then
    echo "[ERROR] Could not find download URL for Thorium Browser .deb package." >&2
    exit 1
  fi
  echo "[INFO] Downloading from: $DEB_URL"
  if wget -O ./thorium-browser.deb "$DEB_URL"; then
    echo "[INFO] Download successful. Installing with nala..."
    if nala install ./thorium-browser.deb -y; then
      echo "[INFO] Thorium Browser installed successfully."
    else
      echo "[ERROR] Installation failed." >&2
      exit 2
    fi
  else
    echo "[ERROR] Download failed." >&2
    exit 3
  fi
else
  echo "[INFO] Thorium Browser is already installed."
fi