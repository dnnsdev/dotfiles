# source: https://github.com/jellyfin/jellyfin-media-player/wiki/Installing-on-Linux

if [ $(which jellyfinmediaplayer) == "" ];
then

  version=$(curl --head https://github.com/jellyfin/jellyfin-media-player/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')
  wget "https://github.com/jellyfin/jellyfin-media-player/releases/download/v$version/jellyfin-media-player_$version-1_amd64-$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).deb" -O jmp.deb

  nala install ./jmp.deb

fi