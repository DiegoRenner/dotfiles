#!/bin/sh
xrandr --output DP-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --mode 1920x1080 --pos 3840x0 --scale 2x2 --rotate normal --output DP-4 --off --output DP-5 --off --output eDP-1-1 --mode 3840x2160 --pos 0x0 --rotate normal
pacwall -ug &
