#!/bin/bash

if ! command -v dotnet >/dev/null 2>&1; then

  # Detect Debian version dynamically
  debian_version=$(grep VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')
  if [[ -z "$debian_version" ]]; then
    echo "Warning: Could not detect Debian version, defaulting to 12" >&2
    debian_version="12"
  fi

  download_url="https://packages.microsoft.com/config/debian/${debian_version}/packages-microsoft-prod.deb"

  wget -q "$download_url" -O packages-microsoft-prod.deb

  dpkg -i packages-microsoft-prod.deb
fi

# Verify installation
if command -v dotnet >/dev/null 2>&1; then
  echo ".NET installation verified"
  dotnet --version
  echo "Available SDKs:"
  dotnet --list-sdks
else
  echo "Warning: .NET installation completed but command not found in PATH" >&2
fi