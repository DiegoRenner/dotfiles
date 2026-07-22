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
        calc_height=$((380 + (lines - 15) * 22))
        max_len=$(awk '{ if (length($0) > max) max = length($0) } END { print max }' /tmp/khal_cache_full.txt)
        if [ -z "$max_len" ]; then max_len=59; fi
        calc_width=$((40 + max_len * 9))
        if [ $calc_width -lt 350 ]; then calc_width=350; fi
        if [ $calc_width -gt 900 ]; then calc_width=900; fi
    fi
    
    focused_width=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .width / .scale | floor' 2>/dev/null)
    if [ -z "$focused_width" ]; then focused_width=1920; fi
    x_pos=$((focused_width - calc_width - 20))
    
    hyprctl dispatch exec "[float; size $calc_width $calc_height; move $x_pos 40; pin] alacritty --class khal_dropdown -e /home/diego/.config/waybar/khal_dropdown.sh"
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

tooltip=$(cat /tmp/khal_cache_next.txt 2>/dev/null || echo "Calendar cache unavailable")
tooltip=${tooltip//&/&amp;}
tooltip=${tooltip//</&lt;}
tooltip=${tooltip//>/&gt;}

cat <<OUT
{"text": "$text", "tooltip": "<tt>${tooltip//$'\n'/\\n}</tt>", "class": "custom-clock"}
OUT
