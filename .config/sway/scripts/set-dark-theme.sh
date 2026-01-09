#!/bin/bash

# Ensure GTK can find themes in user directory
export GTK_DATA_HOME="$HOME/.local/share"
export GTK_THEME_DIR="$HOME/.themes"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Set GTK theme settings
gsettings set org.gnome.desktop.interface gtk-theme 'Aretha-Dark-GTK'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

# Set environment variables for current session
export GTK_THEME='Aretha-Dark-GTK'
export QT_STYLE_OVERRIDE=adwaita-dark
export GTK_APPLICATION_PREFER_DARK_THEME=1

# Update systemd user environment
systemctl --user import-environment \
    GTK_DATA_HOME \
    GTK_THEME_DIR \
    GTK_THEME \
    QT_STYLE_OVERRIDE \
    GTK_APPLICATION_PREFER_DARK_THEME

# Update dbus activation environment
dbus-update-activation-environment --systemd \
    WAYLAND_DISPLAY \
    XDG_CURRENT_DESKTOP \
    GTK_DATA_HOME \
    GTK_THEME_DIR \
    GTK_THEME \
    QT_STYLE_OVERRIDE \
    GTK_APPLICATION_PREFER_DARK_THEME

echo "Dark theme environment configured"