nala install fonts-font-awesome -y
#!/bin/bash
set -euo pipefail

# Check for required commands
for cmd in nala wget unzip; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[ERROR] Required command '$cmd' not found. Please install it first." >&2
    exit 1
  fi
done

# Use current user if $username is not set
FONT_USER="${username:-$USER}"
FONT_DIR="/home/$FONT_USER/.fonts"
mkdir -p "$FONT_DIR"

nala install fonts-font-awesome -y

# Skip installation if fonts directory already contains files
if [[ -z "$(ls -A "$FONT_DIR" 2>/dev/null)" ]]; then
  TMPDIR=$(mktemp -d)
  cd "$TMPDIR"

  for FONT in FiraCode Meslo; do
    ZIP_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/${FONT}.zip"
    if wget -q "$ZIP_URL"; then
      echo "Installing $FONT font"
      unzip -oq "${FONT}.zip" -d "$FONT_DIR"
    else
      echo "Warning: Failed to download $FONT font" >&2
    fi
  done

  rm -f ./*.zip
  cd - >/dev/null
  rm -rf "$TMPDIR"
else
  echo "[INFO] Fonts already present in $FONT_DIR, skipping installation."
fi