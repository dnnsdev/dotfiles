#!/bin/bash

# Source dark theme environment
export GTK_THEME=Aretha-Dark-GTK:dark
export QT_STYLE_OVERRIDE=adwaita-dark
export GTK_APPLICATION_PREFER_DARK_THEME=1

# Launch the application with the dark theme environment
exec "$@"