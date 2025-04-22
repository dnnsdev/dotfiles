#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script" 2>&1
  exit 1
fi

# first user
username=$(id -u -n 1000)

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

if [ $(which docker) == "" ];
then

  apt-get install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null

  nala install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  groupadd docker
  usermod -aG docker $username

fi

# > Docker

# < (vs)code
if [ $(which code) == "" ];
then

  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

  install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null

fi
# > (vs)code

# < fastfetch
if [ $(which fastfetch) == "" ];
then

  wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.33.0/fastfetch-linux-amd64.deb
  dpkg -i fastfetch-linux-amd64.deb

fi

# > fastfetch

# < spotify

if [ $(which spotify) == "" ];
then

  curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
  
  echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list

fi

# > spotify

# < owncloud-client

if [ $(which owncloud) == "" ];
then

  wget -nv https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Debian_12/Release.key -O - | gpg --dearmor | tee /etc/apt/trusted.gpg.d/owncloud-client.gpg > /dev/null

  echo 'deb https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Debian_12/ /' | tee -a /etc/apt/sources.list.d/owncloud-client.list

fi

# > owncloud-client

# source: https://github.com/jellyfin/jellyfin-media-player/wiki/Installing-on-Linux

if [ $(which jellyfinmediaplayer) == "" ];
then

  version=$(curl --head https://github.com/jellyfin/jellyfin-media-player/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')
  wget "https://github.com/jellyfin/jellyfin-media-player/releases/download/v$version/jellyfin-media-player_$version-1_amd64-$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).deb" -O jmp.deb

  nala install ./jmp.deb

fi

# > owncloud client

# > starship

if [ $(which starship) == "" ];
then

  curl -sS https://starship.rs/install.sh | sh

fi

# < starship

# < fonts

nala install fonts-font-awesome -y

# skip installation of fonts when the directory already contains files
if ![ "$(ls -A /home/$username/.fonts)" ];
then

  # firacode
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip

  unzip FiraCode.zip -d /home/$username/.fonts

  # meslo
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Meslo.zip

  unzip Meslo.zip -d /home/$username/.fonts

  # chown whole directory for first user
  chown -R $username:$username /home/$username

  # Reloading font cache
  fc-cache -vf

  # Removing zip Files
  rm *.zip

fi

# > fonts

# < thorium-browser
if [ $(which thorium-browser) == "" ];
then

  wget -O ./thorium-browser.deb "$(curl -s https://api.github.com/repos/Alex313031/Thorium/releases/latest | grep browser_download_url | grep .deb | cut -d '"' -f 4)"

  nala install ./thorium-browser.deb -y

fi

# > thorium

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

# < rancher-desktop
if [ $(which rancher-desktop) == ""];
then
  # add user to kvm group
  usermod -a -G kvm $username

  # Allow Traefik (default ingress ctrl) to listen to port 80
  sysctl -w net.ipv4.ip_unprivileged_port_start=80

  curl -s https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/Release.key | gpg --dearmor | dd status=none of=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg
  echo 'deb [signed-by=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg] https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/ ./' | dd status=none of=/etc/apt/sources.list.d/isv-rancher-stable.list

fi

# >

# < dotnet sdk

if [ $(which dotnet) == "" ];
then

  wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

  dpkg -i packages-microsoft-prod.deb

fi

# > dotnet sdk

# < vesktop

if [ $(which vesktop) == "" ];
then

  wget https://vencord.dev/download/vesktop/amd64/deb -O vesktop.deb

  dpkg -i vesktop.deb

fi

# > vesktop

# < VSCodium

if [ $(which codium) == "" ];
then

  wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
      | gpg --dearmor \
      | dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

  echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
      | tee /etc/apt/sources.list.d/vscodium.list

fi

# > VSCodium

apt-get install $(grep -o '^[^#]*' pkglist)

# as a baseinstall i use debian 12 w/ kde
# so.. here should follow stuff to cleanup (obsolete) packages from kde
# todo: remove packages (such as (neo)vim) i don't need
apt-get remove $(grep -o '^[^#]*' shitlist)

# remove all downloaded debs
rm *.deb

# Effort to remove KDE leftovers
apt autoremove --purge kde*

# clean up apt
apt autoremove
apt autoclean