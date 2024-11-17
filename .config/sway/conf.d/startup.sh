#!/bin/bash

# Startup file
apps=( owncloud vesktop swaync )

for app in "${apps[@]}"
do
    swaymsg "exec --no-startup-id $app"
done