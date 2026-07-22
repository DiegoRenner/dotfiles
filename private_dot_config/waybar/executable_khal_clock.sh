#!/bin/bash
if [ "$1" = "--click" ]; then
    state=$(cat /tmp/waybar_clock_state 2>/dev/null || echo "time")
    if [ "$state" = "time" ]; then
        echo "date" > /tmp/waybar_clock_state
    else
        echo "time" > /tmp/waybar_clock_state
    fi
    pkill -RTMIN+8 waybar
    exit 0
fi

(khal calendar today 7d > /tmp/khal_cache.txt.tmp && mv /tmp/khal_cache.txt.tmp /tmp/khal_cache.txt) >/dev/null 2>&1 </dev/null &

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
