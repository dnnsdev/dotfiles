#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] This script must be run as root."
  exit 1
fi

if ! command -v jellyfinmediaplayer >/dev/null 2>&1; then

  # Get the latest release tag
  version=$(curl -s https://api.github.com/repos/jellyfin/jellyfin-desktop/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
  
  echo "[INFO] Installing Jellyfin Media Player version $version"
  
  # Get the download URL for the .deb file containing 'trixie' (debian 13 codename)
  download_url=$(curl -s https://api.github.com/repos/jellyfin/jellyfin-desktop/releases/latest | grep -oP '"browser_download_url": "\K[^"]*trixie[^"]*\.deb')
  
  if [ -z "$download_url" ]; then
    echo "[ERROR] Could not find a .deb file containing 'trixie'"
    exit 1
  fi

  echo "[INFO] Downloading from: $download_url"

  wget "$download_url" -O jmp.deb

  dpkg -i ./jmp.deb

  rm ./jmp.deb

fi