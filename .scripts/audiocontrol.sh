#!/bin/sh
gpu=$(lspci | awk '/VGA/ { print $5; }')

if [ $gpu == "NVIDIA" ]; then
	NR=$"2"
else
	NR=$"1"
fi

current=$(pacmd dump-volumes | awk 'NR=='$NR'{print $8}' | sed 's/\%//')
[ $current -lt 150 ] && pactl set-sink-volume @DEFAULT_SINK@ +5% && $refresh_i3status

