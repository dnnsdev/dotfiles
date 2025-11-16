#!/bin/sh

set -e

# Handle termination signals gracefully
trap cleanup TERM INT

while true; do
    metadata=$(playerctl --player=spotify metadata --format "{{status}}|{{artist}}|{{title}}" 2>/dev/null)
    
    if [ -z "$metadata" ] || [ "$metadata" = "No players found" ]; then
        echo ""
    else
        status=$(echo "$metadata" | cut -d'|' -f1)
        artist=$(echo "$metadata" | cut -d'|' -f2)
        title=$(echo "$metadata" | cut -d'|' -f3)
        
        if [ "$status" = "Playing" ]; then
            player_icon="▶"
        else
            player_icon="⏸"
        fi

        echo "$player_icon $artist - $title"
    fi

    sleep 2

  done