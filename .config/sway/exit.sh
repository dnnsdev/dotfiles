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
        --background=#282828
    #swaynag --background 333333 --border 333333 --border-bottom 333333 --button-background 1F1F1F \
	#    --button-border-size 0 --button-padding 8 --text FFFFFF --button-text FFFFFF --edge bottom \
	#    -t warning -m 'Do you really want to log out?' -B 'You heard me!' 'swaymsg exit'
fi
