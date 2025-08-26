#!/bin/bash

if ! command -v spotify >/dev/null 2>&1; then

  curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
  
  echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list

fi