#!/bin/bash

# Set environment variables for dark theme
export GTK_THEME=Aretha-Dark-GTK:dark
export QT_STYLE_OVERRIDE=adwaita-dark  
export GTK_APPLICATION_PREFER_DARK_THEME=1
export gtk-application-prefer-dark-theme=1

# Update systemd user environment
systemctl --user set-environment GTK_THEME="$GTK_THEME"
systemctl --user set-environment QT_STYLE_OVERRIDE="$QT_STYLE_OVERRIDE"
systemctl --user set-environment GTK_APPLICATION_PREFER_DARK_THEME="$GTK_APPLICATION_PREFER_DARK_THEME"

# Set gsettings
gsettings set org.gnome.desktop.interface gtk-theme 'Aretha-Dark-GTK'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface text-scaling-factor 1.0

# Update dbus activation environment
dbus-update-activation-environment --systemd \
    WAYLAND_DISPLAY \
    XDG_CURRENT_DESKTOP \
    GTK_THEME \
    QT_STYLE_OVERRIDE \
    GTK_APPLICATION_PREFER_DARK_THEME

echo "Dark theme environment configured"