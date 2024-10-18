# im just lazy
# prefer to run this as root

# prerequisites for stuff below
apt-get update
apt-get install wget gpg apt-transport-https

# install repos

# < (vs)code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
# > (vs)code

# < fastfetch
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.27.1/fastfetch-linux-amd64.deb
dpkg -i fastfetch-linux-amd64.deb

rm fastfetch-linux-amd64.deb

# > fastfetch

# < spotify

curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list

# > spotify

# < owncloud-client

wget -nv https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Debian_12/Release.key -O - | gpg --dearmor | tee /etc/apt/trusted.gpg.d/owncloud-client.gpg > /dev/null

# > owncloud-client

# < owncloud-client

# source: https://github.com/jellyfin/jellyfin-media-player/wiki/Installing-on-Linux

version=$(curl --head https://github.com/jellyfin/jellyfin-media-player/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')
wget "https://github.com/jellyfin/jellyfin-media-player/releases/download/v$version/jellyfin-media-player_$version-1_amd64-$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).deb" -O jmp.deb

apt install ./jmp.deb

rm jmp.deb

# > owncloud client

apt-get install $(grep -o '^[^#]*' pkglist)
