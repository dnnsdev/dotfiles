#!/bin/bash

nala install fonts-font-awesome -y

# skip installation of fonts when the directory already contains files
if [[ -z "$(ls -A "/home/$username/.fonts" 2>/dev/null)" ]]; then

  cd /tmp  # Use tmp directory for downloads
  
  # firacode
  if wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip; then
    echo "Installing FiraCode font"
    
    unzip -oq FiraCode.zip -d "/home/$username/.fonts"
  else
    echo "Warning: Failed to download FiraCode font" >&2
  fi

  # meslo
  if wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Meslo.zip; then
    echo "Installing Meslo font"
    
    unzip -oq Meslo.zip -d "/home/$username/.fonts"
  else
    echo "Warning: Failed to download Meslo font" >&2
  fi

  rm *.zip  # Clean up any remaining zip files
  cd "$builddir"  # Return to original directory

fi