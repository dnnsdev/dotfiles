#!/bin/bash

if ! command -v brave-browser >/dev/null 2>&1; then

    echo "Brave browser not found. Installing."

    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

    curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

    apt update
    apt install brave-browser

    echo "Brave browser installation complete."

fi