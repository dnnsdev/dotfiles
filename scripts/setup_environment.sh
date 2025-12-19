#!/bin/bash

set -e # exit on error
set -u # exit on undefined variable

# Check if script is run as root
if [[ "$EUID" -ne 0 ]]; then
  echo "You must be a root user to run this script" 2>&1
  exit 1
fi

# first user
username=$(id -u -n 1000)
if [[ -z "$username" ]]; then
  echo "No user with UID 1000 found" >&2
  exit 1
fi

# add first user to several groups
usermod -aG sudo "$username"
usermod -aG libvirt "$username"
usermod -aG kvm "$username"

sudoers_file="/etc/sudoers.d/$username"
if [[ ! -f "$sudoers_file" ]]; then
  echo "$username ALL=(ALL:ALL) ALL" > "$sudoers_file"
  chmod 440 "$sudoers_file"
fi

# build directory
builddir="$(pwd)"

mkdir -p "/home/$username/Pictures"
mkdir -p "/home/$username/Pictures/backgrounds"

chown -R "$username:$username" "/home/$username"

# prerequisites for stuff below
apt-get update
apt-get upgrade
apt-get install ca-certificates curl wget gpg apt-transport-https nala 

# Source external setup scripts if they exist
for script in setup/audio.sh setup/fonts.sh setup/brave.sh setup/vscode.sh setup/spotify.sh setup/owncloud-client.sh setup/jellyfinmediaplayer.sh setup/starship.sh setup/thorium-browser.sh setup/rancher-desktop.sh setup/vesktop.sh; do
  if [[ -f "$script" ]]; then
    echo "Sourcing $script"
    source "$script"
  else
    echo "Warning: $script not found, skipping..." >&2
  fi
done

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
rm -f ./*.deb

# Effort to remove KDE leftovers (be more careful)
if dpkg -l | grep -q kde; then
  apt-get autoremove --purge -y 'kde*' || true
fi

# clean up apt
apt autoremove
apt autoclean

echo "Environment setup completed successfully!"