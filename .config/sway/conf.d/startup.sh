#!/bin/bash

# Startup file
apps=( owncloud vesktop swaync )

for app in "${apps[@]}"
do
    swaymsg "exec --no-startup-id $app"
done

#virsh net-define /usr/share/libvirt/networks/default.xml

#virsh net-autostart default

#virsh net-start default