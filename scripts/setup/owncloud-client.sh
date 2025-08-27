#!/bin/bash

if ! command -v owncloud-client >/dev/null 2>&1; then

  wget -nv https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Debian_12/Release.key -O - | gpg --dearmor | tee /etc/apt/trusted.gpg.d/owncloud-client.gpg > /dev/null

  echo 'deb https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Debian_12/ /' | tee -a /etc/apt/sources.list.d/owncloud-client.list

  apt update

  apt install owncloud-client

fi