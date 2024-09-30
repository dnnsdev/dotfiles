#!/bin/bash

# Startup file
apps=( owncloud vesktop )

for app in "${apps[@]}"
do
    swaymsg "exec --no-startup-id $app"
done