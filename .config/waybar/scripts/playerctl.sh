#!/bin/sh

while true
  do
    player_status=$(playerctl status --player=spotify 2> /dev/null)
    
    if [ $player_status = "No players found" or $player_status = "" ];
        then
            f=""
    else
        player_icon=""

        if [ $player_status = "Playing" ];
            then
                player_icon=""
            else
                player_icon=" "
        fi

        echo "$player_icon $(playerctl --player=spotify metadata artist) - $(playerctl --player=spotify metadata title)"
    fi

    sleep 2

  done