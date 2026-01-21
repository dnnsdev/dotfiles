#!/bin/bash

set -e # exit on error
set -u # exit on undefined variable
set -o pipefail # catch errors in pipes

# Function to clean up
cleanup() {
  echo "[INFO] Running cleanup tasks."

  # clean up apt
  apt autoremove -y
  apt autoclean -y

  # clean up any downloaded debs in current directory
  rm -f ./*.deb
}

trap cleanup EXIT

# Check if script is run as root
if [[ "$EUID" -ne 0 ]]; then
  echo "[ERROR] You must be a root user to run this script" 2>&1
  exit 1
fi

# first user
username=$(id -u -n 1000)
if [[ -z "$username" ]]; then
  echo "[ERROR] No user with UID 1000 found" >&2
  exit 1
fi

echo "[INFO] Setting up environment for user: $username"

# Define groups that the user needs to be added to
user_groups=(
  "sudo"
  "libvirt"
  "kvm"
)

# user group assignments
for group in "${user_groups[@]}"; do
  echo "[INFO] Ensuring required group ($group) exists."
  groupadd -f "$group"

  echo "[INFO] Adding $username to required group ($group)."
  usermod -aG "$group" "$username"
done

sudoers_file="/etc/sudoers.d/$username"
if [[ ! -f "$sudoers_file" ]]; then
  echo "$username ALL=(ALL:ALL) ALL" > "$sudoers_file"
  chmod 440 "$sudoers_file"
fi

# build directory
builddir="$(pwd)"

echo "[INFO] Creating user directories."
mkdir -p "/home/$username/Pictures"
mkdir -p "/home/$username/Pictures/backgrounds"
mkdir -p "/home/$username/.ssh/sockets"

chown -R "$username:$username" "/home/$username"

# prerequisites for stuff below
echo "[INFO] Updating system and installing prerequisites."
apt-get update
apt-get upgrade
apt-get install ca-certificates curl wget gpg apt-transport-https nala 

# Source external setup scripts if they exist
echo "[INFO] Running external setup scripts."

# Define setup scripts to execute
setup_scripts=(
  "setup/audio.sh"
  "setup/eza.sh"
  "setup/fonts.sh"
  "setup/brave.sh"
  "setup/vscode.sh"
  "setup/spotify.sh"
  "setup/owncloud-client.sh"
  "setup/jellyfinmediaplayer.sh"
  "setup/starship.sh"
  "setup/rancher-desktop.sh"
  "setup/vesktop.sh"
)

for script in "${setup_scripts[@]}"; do
  if [[ -f "$script" ]]; then
    echo "[INFO] Sourcing $script"
    source "$script" || { echo "[ERROR] Failed to source $script, continuing." >&2; }
  else
    echo "[WARNING] $script not found, skipping." >&2
  fi
done

# Install packages from pkglist if file exists
if [[ -f "pkglist" ]]; then
  echo "[INFO] Installing packages from pkglist."

  # Filter out comments and empty lines, then install
  packages=$(grep -v '^#' pkglist | grep -v '^$' | tr '\n' ' ')
  if [[ -n "$packages" ]]; then
    apt-get install -y $packages
  fi
else
  echo "[WARNING] pkglist file not found" >&2
fi

# Remove packages from shitlist if file exists  
if [[ -f "shitlist" ]]; then
  echo "[INFO] Removing packages from shitlist."
  packages_to_remove=$(grep -v '^#' shitlist | grep -v '^$' | tr '\n' ' ')
  if [[ -n "$packages_to_remove" ]]; then
    apt-get remove -y $packages_to_remove || true
  fi
else
  echo "[WARNING] shitlist file not found" >&2
fi

# Effort to remove KDE leftovers (be more careful)
if dpkg -l | grep -q kde; then
  echo "[INFO] Removing KDE packages."
  apt-get autoremove --purge -y 'kde*' || true
fi

# Set SUID on brightnessctl to allow non-root users to change brightness
chmod u+s $(which brightnessctl)

cp ./systemd/powertop.service /etc/systemd/system/powertop.service
systemctl daemon-reload
systemctl enable --now powertop.service

echo "Environment setup completed successfully!"