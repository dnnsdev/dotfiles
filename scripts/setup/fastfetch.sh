#!/bin/bash

if ! command -v fastfetch >/dev/null 2>&1; then

  wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.33.0/fastfetch-linux-amd64.deb
  dpkg -i fastfetch-linux-amd64.deb

fi