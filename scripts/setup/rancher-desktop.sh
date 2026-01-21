#!/bin/bash

if ! command -v rancher-desktop >/dev/null 2>&1; then
  echo "[INFO] Installing rancher-desktop."

  # Allow Traefik (default ingress ctrl) to listen to port 80
  sysctl -w net.ipv4.ip_unprivileged_port_start=80
  curl -s https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/Release.key | gpg --dearmor | dd status=none of=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg
  echo 'deb [signed-by=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg] https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/ ./' | dd status=none of=/etc/apt/sources.list.d/isv-rancher-stable.list

  echo "[INFO] Updated package sources for rancher-desktop."
else
  echo "[INFO] rancher-desktop is already installed."
fi