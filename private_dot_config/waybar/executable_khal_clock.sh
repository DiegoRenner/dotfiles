#!/bin/bash
if [ "$1" = "--right-click" ]; then
    if pgrep -f "alacritty --class khal_dropdown" >/dev/null; then
        pkill -f "alacritty --class khal_dropdown"
        exit 0
    fi
    calc_height=320
    calc_width=600
    if [ -f /tmp/khal_cache.txt ]; then
        lines=$(wc -l < /tmp/khal_cache.txt)
        calc_height=$((320 + (lines - 15) * 20))
        max_len=$(awk '{ if (length($0) > max) max = length($0) } END { print max }' /tmp/khal_cache.txt)
        if [ -z "$max_len" ]; then max_len=59; fi
        calc_width=$((40 + max_len * 9))
        if [ $calc_width -lt 350 ]; then calc_width=350; fi
        if [ $calc_width -gt 900 ]; then calc_width=900; fi
    fi
    hyprctl dispatch exec "[float; size $calc_width $calc_height; move 1350 40; pin] alacritty --class khal_dropdown -e /home/diego/.config/waybar/khal_dropdown.sh"
    exit 0
elif [ "$1" = "--click" ]; then
    state=$(cat /tmp/waybar_clock_state 2>/dev/null || echo "time")
    if [ "$state" = "time" ]; then
        echo "date" > /tmp/waybar_clock_state
    else
        echo "time" > /tmp/waybar_clock_state
    fi
    pkill -RTMIN+8 waybar
    exit 0
fi

(khal calendar today 7d > /tmp/khal_cache.txt.tmp && mv /tmp/khal_cache.txt.tmp /tmp/khal_cache.txt) &

state=$(cat /tmp/waybar_clock_state 2>/dev/null || echo "time")
if [ "$state" = "date" ]; then
    text=$(date "+%Y-%m-%d")
else
    text=$(date "+%H:%M")
fi

tooltip=$(cat /tmp/khal_cache.txt 2>/dev/null || echo "Calendar cache unavailable")
tooltip=${tooltip//&/&amp;}
tooltip=${tooltip//</&lt;}
tooltip=${tooltip//>/&gt;}

cat <<OUT
{"text": "$text", "tooltip": "<tt>${tooltip//$'\n'/\\n}</tt>", "class": "custom-clock"}
OUT
