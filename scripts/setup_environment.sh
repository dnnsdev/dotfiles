#!/bin/bash

set -e # exit on error
set -u # exit on undefined variable

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script" 2>&1
  exit 1
fi

# first user
username=$(id -u -n 1000)
if [[ -z "$username" ]]; then
  echo "No user with UID 1000 found" >&2
  exit 1
fi

# build directory
builddir=$(pwd)

mkdir -p /home/$username/Pictures
mkdir -p /home/$username/Pictures/backgrounds
# chown -R $username:$username /home/$username

# prerequisites for stuff below
apt-get update
apt-get upgrade
apt-get install ca-certificates curl wget gpg apt-transport-https nala 

# install repos

# < Docker
if ! command -v docker >/dev/null 2>&1; then
  mkdir -p /etc/apt/keyrings
  apt-get install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

  nala install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  if ! getent group docker >/dev/null; then
    groupadd docker
  fi

  usermod -aG docker $username

fi

# > Docker

# < (vs)code
if ! command -v code >/dev/null 2>&1; then

  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

  install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null

  rm packages.microsoft.gpg
fi
# > (vs)code

# Source external setup scripts if they exist
for script in setup/fastfetch.sh setup/spotify.sh setup/owncloud-client.sh setup/jellyfinmediaplayer.sh setup/starship.sh setup/thorium-browser.sh setup/rancher-desktop.sh setup/dotnet-sdk.sh setup/homebrew.sh setup/vesktop.sh; do
  if [[ -f "$script" ]]; then
    echo "Sourcing $script"
    source "$script"
  else
    echo "Warning: $script not found, skipping..." >&2
  fi
done

# < fonts

nala install fonts-font-awesome -y

# skip installation of fonts when the directory already contains files
if [[ -z "$(ls -A "/home/$username/.fonts" 2>/dev/null)" ]]; then
then

  cd /tmp  # Use tmp directory for downloads
  
  # firacode
  if wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip; then
    unzip -q FiraCode.zip -d "/home/$username/.fonts"
    rm FiraCode.zip
  else
    echo "Warning: Failed to download FiraCode font" >&2
  fi

  # meslo
  if wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Meslo.zip; then
    unzip -q Meslo.zip -d "/home/$username/.fonts"
    rm Meslo.zip
  else
    echo "Warning: Failed to download Meslo font" >&2
  fi

  cd "$builddir"  # Return to original directory

fi

# > fonts

# < librewolf
#if [ $(which librewolf) == "" ];
#then

#  wget -O- https://download.opensuse.org/repositories/home:/bgstack15:/aftermozilla/Debian_Unstable/Release.key | gpg --dearmor -o /etc/apt/keyrings/home_bgstack15_aftermozilla.gpg

#  tee /etc/apt/sources.list.d/home_bgstack15_aftermozilla.sources << EOF > /dev/null
#  Types: deb
#  URIs: https://download.opensuse.org/repositories/home:/bgstack15:/aftermozilla/Debian_Unstable/
#  Suites: /
#  Signed-By: /etc/apt/keyrings/home_bgstack15_aftermozilla.gpg
#EOF

#  nala update

#  nala install librewolf -y

#fi

# > librewolf

# < VSCodium

if ! command -v codium >/dev/null 2>&1; then
then

  wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
      | gpg --dearmor \
      | dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

  echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
      | tee /etc/apt/sources.list.d/vscodium.list

fi

# > VSCodium

# Install packages from pkglist if file exists
if [[ -f "pkglist" ]]; then
  # Filter out comments and empty lines, then install
  packages=$(grep -v '^#' pkglist | grep -v '^$' | tr '\n' ' ')
  if [[ -n "$packages" ]]; then
    apt-get install -y $packages
  fi
else
  echo "Warning: pkglist file not found" >&2
fi

# Remove packages from shitlist if file exists  
if [[ -f "shitlist" ]]; then
  packages_to_remove=$(grep -v '^#' shitlist | grep -v '^$' | tr '\n' ' ')
  if [[ -n "$packages_to_remove" ]]; then
    apt-get remove -y $packages_to_remove || true  # Don't fail if packages don't exist
  fi
else
  echo "Warning: shitlist file not found" >&2
fi

# Clean up any downloaded debs in current directory
rm -f *.deb

# Effort to remove KDE leftovers (be more careful)
if dpkg -l | grep -q kde; then
  apt-get autoremove --purge -y 'kde*' || true
fi

# clean up apt
apt autoremove
apt autoclean

echo "Environment setup completed successfully!"