#!/bin/bash

# Start swww-daemon if not already running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    # Wait for the daemon to initialize
    while ! swww query > /dev/null 2>&1; do
        sleep 0.5
    done
fi

# Find the internal monitor name by description
# The description "BOE NE160QDM-NYJ" is from the hyprland.conf
INTERNAL_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.description | contains("BOE")) | .name')

# Default wallpaper for all monitors
swww img /home/diego/downloads/8642900.gif

if [ -n "$INTERNAL_MONITOR" ]; then
    echo "Setting wallpaper for internal monitor: $INTERNAL_MONITOR"
    swww img -o "$INTERNAL_MONITOR" /home/diego/downloads/2825704.gif
else
    echo "Internal monitor not found by description."
fi
