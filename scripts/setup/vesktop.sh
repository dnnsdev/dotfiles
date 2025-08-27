#!/bin/bash

if ! command -v vesktop >/dev/null 2>&1; then

  wget https://vencord.dev/download/vesktop/amd64/deb -O vesktop.deb

  dpkg -i vesktop.deb

else
  echo "Vesktop is already installed, skipping..."
fi