#!/bin/bash
# Enable mouse tracking in xterm/alacritty
echo -en "\e[?1000h"

cat /tmp/khal_cache_full.txt
echo -e "\n\e[90m(Click anywhere to open full calendar)\e[0m"

# Wait for 1 character of input
read -rs -n 1 char

# Disable mouse tracking
echo -en "\e[?1000l"

# If the input was an escape sequence, check if it's a mouse click
if [[ "$char" == $'\e' ]]; then
    read -rs -t 0.05 -n 2 rest
    if [[ "$rest" == "[M" ]] || [[ "$rest" == "[<" ]]; then
        hyprctl dispatch exec "[float; size 1200 800; center] alacritty --class khal_calendar -e khal interactive" > /dev/null 2>&1
    fi
fi
