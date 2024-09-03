#!/bin/bash

if [[ ! $(pgrep -x "swaynag") ]]; then
	swaynag -t warning \
        -m 'Quit sway?' \
        -b 'Suspend' 'systemctl suspend' \
        -b 'Shutdown' 'systemctl -i poweroff' \
        -b 'Reboot' 'systemctl -i reboot' \
        -b 'Yes, exit sway' 'swaymsg exit' \
        --button-background=#FF9100 \
        --button-border-size=1px \
        --border=#FCC99D \
        #--text=#092E47 \
        --background=#28282
fi
