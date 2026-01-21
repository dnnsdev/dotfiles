#!/bin/bash

set -e

DEB_FILE="packages-microsoft-prod.deb"

# Function to clean up
cleanup() {
    if [[ -f "$DEB_FILE" ]]; then
        echo "[INFO] Cleaning up $DEB_FILE."
        rm -f "$DEB_FILE"
    fi
}

# Ensure cleanup on exit
trap cleanup EXIT

if ! command -v dotnet >/dev/null 2>&1; then

  echo "[INFO] .NET SDK not found. Proceeding with installation."

  # Detect Debian version dynamically
  debian_version=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
  if [[ -z "$debian_version" ]]; then
    echo "[INFO] VERSION_ID not found in /etc/os-release."
    echo "[INFO] Defaulting to Debian 13."

    debian_version="13"
  fi

  download_url="https://packages.microsoft.com/config/debian/${debian_version}/packages-microsoft-prod.deb"

  wget -q "$download_url" -O "$DEB_FILE"

  dpkg -i "$DEB_FILE"

  apt-get update
  apt-get install -y dotnet-sdk-10.0
fi

# Verify installation
if command -v dotnet >/dev/null 2>&1; then
  echo "[INFO] .NET installation verified"
  dotnet --version
  echo "[INFO] Available SDKs:"
  dotnet --list-sdks
else
  echo "[WARNING] .NET installation completed but command not found in PATH" >&2
fi