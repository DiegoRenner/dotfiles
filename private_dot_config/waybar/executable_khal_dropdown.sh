#!/bin/bash
# Use alternate screen buffer to prevent ANY scrollback or cutoff at the top
tput smcup
tput clear
tput cup 0 0

# Enable SGR mouse tracking and hide cursor
echo -en "\e[?1000h\e[?1006h\e[?25l"

cat /tmp/khal_cache_full.txt
echo -e "\n\e[90m(Click anywhere to open full calendar)\e[0m"

while true; do
    read -rs -n 1 char
    if [[ "$char" == $'\e' ]]; then
        read -rs -t 0.05 -n 2 rest
        if [[ "$rest" == "[<" ]]; then
            # SGR mode mouse event: \e[<cb;cx;cy(M or m)
            read -rs -d 'M' -t 0.1 event 2>/dev/null || read -rs -d 'm' -t 0.1 event 2>/dev/null
            cb=$(echo "$event" | cut -d ';' -f 1)
            # cb=0 is left click, 1 is middle, 2 is right. 64/65 are scrolls.
            if [[ "$cb" == "0" ]] || [[ "$cb" == "2" ]]; then
                hyprctl dispatch exec "[float; size 1200 800; center] alacritty --class khal_calendar -e khal interactive" > /dev/null 2>&1
                break
            fi
            # If it's a scroll, ignore and loop again
        elif [[ -z "$rest" ]]; then
            break # Escape key pressed
        fi
    else
        break # Any other key pressed
    fi
done

echo -en "\e[?1006l\e[?1000l\e[?25h"
tput rmcup
