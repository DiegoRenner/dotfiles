#!/bin/bash
# Rofi Script Modi: Aliases & Apps
CACHE="/home/diego/.config/fish/alias_cache.txt"

if [ -z "$1" ]; then
    # No argument: Rofi wants the list to display
    cat "$CACHE"
else
    # Selection made: Launch it via Hyprland's dispatcher
    # We use hyprctl dispatch exec to avoid hanging Rofi
    hyprctl dispatch exec -- fish -c "$1"
    
    # Force rofi to close (sometimes needed in script mode)
    killall rofi
    exit 0
fi
