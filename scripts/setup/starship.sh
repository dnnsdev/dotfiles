#!/bin/bash

if ! command -v starship >/dev/null 2>&1; then

  echo "[INFO] Starship prompt not found. Proceeding with installation."

  curl -sS https://starship.rs/install.sh | sh

fi