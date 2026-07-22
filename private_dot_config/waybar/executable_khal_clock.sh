#!/bin/bash
if [ "$1" = "--right-click" ]; then
    if pgrep -f "alacritty --class khal_dropdown" >/dev/null; then
        pkill -f "alacritty --class khal_dropdown"
        exit 0
    fi
    calc_height=320
    calc_width=600
    if [ -f /tmp/khal_cache_full.txt ]; then
        lines=$(wc -l < /tmp/khal_cache_full.txt)
        calc_height=$((320 + (lines - 15) * 21))
        if [ $calc_height -lt 240 ]; then calc_height=240; fi
        max_len=$(awk '{ if (length($0) > max) max = length($0) } END { print max }' /tmp/khal_cache_full.txt)
        if [ -z "$max_len" ]; then max_len=59; fi
        calc_width=$((80 + max_len * 10))
        if [ $calc_width -lt 350 ]; then calc_width=350; fi
        if [ $calc_width -gt 900 ]; then calc_width=900; fi
    fi
    
    # Anchor the dropdown's TOP-RIGHT corner at the cursor (global logical
    # coords), clamped into the focused monitor so it never opens off-screen.
    pos=$(hyprctl cursorpos 2>/dev/null)
    cx=${pos%%,*}; cx=${cx%%.*}
    cy=${pos#*, }; cy=${cy%% *}; cy=${cy%%.*}
    read -r mon_x mon_y mon_w mon_h <<< "$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused) | "\(.x) \(.y) \((.width / .scale) | floor) \((.height / .scale) | floor)"')"
    case "$cx" in ''|*[!0-9-]*) cx=$(( ${mon_x:-0} + ${mon_w:-1920} - 20 )) ;; esac
    case "$cy" in ''|*[!0-9-]*) cy=$(( ${mon_y:-0} + 40 )) ;; esac
    mon_x=${mon_x:-0}; mon_y=${mon_y:-0}; mon_w=${mon_w:-1920}; mon_h=${mon_h:-1080}
    x_pos=$((cx - calc_width))
    y_pos=$cy
    [ "$x_pos" -lt "$mon_x" ] && x_pos=$mon_x
    max_y=$((mon_y + mon_h - calc_height))
    [ "$y_pos" -gt "$max_y" ] && y_pos=$max_y
    [ "$y_pos" -lt "$mon_y" ] && y_pos=$mon_y

    hyprctl dispatch exec "[float; size $calc_width $calc_height; move $x_pos $y_pos; pin] alacritty --class khal_dropdown -e /home/diego/.config/waybar/khal_dropdown.sh"
    exit 0
elif [ "$1" = "--click" ]; then
    if pgrep -f "alacritty --class khal_dropdown" >/dev/null; then
        pkill -f "alacritty --class khal_dropdown"
        exit 0
    fi
    state=$(cat /tmp/waybar_clock_state 2>/dev/null || echo "time")
    if [ "$state" = "time" ]; then
        echo "date" > /tmp/waybar_clock_state
    else
        echo "time" > /tmp/waybar_clock_state
    fi
    pkill -RTMIN+8 waybar
    exit 0
fi

# Generate both full calendar and next appointment caches
(
    khal calendar today 7d > /tmp/khal_cache_full.txt.tmp && mv /tmp/khal_cache_full.txt.tmp /tmp/khal_cache_full.txt
    khal list now 30d | grep -v '^\s*$' | head -n 2 > /tmp/khal_cache_next.txt.tmp && mv /tmp/khal_cache_next.txt.tmp /tmp/khal_cache_next.txt
) >/dev/null 2>&1 </dev/null &

state=$(cat /tmp/waybar_clock_state 2>/dev/null || echo "time")
if [ "$state" = "date" ]; then
    text=$(date "+%Y-%m-%d")
else
    text=$(date "+%H:%M")
fi

if [ -f /tmp/khal_dropdown_open ]; then
    tooltip=""
else
    tooltip=$(cat /tmp/khal_cache_next.txt 2>/dev/null || echo "Calendar cache unavailable")
    tooltip=${tooltip//&/&amp;}
    tooltip=${tooltip//</&lt;}
    tooltip=${tooltip//>/&gt;}
    tooltip="<tt>${tooltip//$'\n'/\\n}</tt>"
fi

cat <<OUT
{"text": "$text", "tooltip": "$tooltip", "class": "custom-clock"}
OUT
