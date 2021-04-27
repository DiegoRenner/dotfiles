#!/bin/sh

gpu=$(lspci | awk '/VGA/ { print $5; }')

if [ $gpu == "NVIDIA" ]; then
	#xrandr --output DP-0 --off --output DP-1 --scale 2x2 --mode 1680x1050 --pos 3840x0 --rotate normal --output DP-2 --mode 3840x2160 --pos 0x0 --rotate normal --output DP-3 --off --output DP-4 --off --output DP-5 --off --output DP-6 --off
#xrandr --output DP-0 --off --output DP-1 --mode 1920x1080 --pos 3840x0 --rotate left --scale 2x2 --output DP-2 --mode 3840x2160 --pos 0x0 --rotate normal --output DP-3 --off --output DP-4 --off --output DP-5 --off --output DP-6 --off
#xrandr --output DP-0 --off --output DP-1 --off --output DP-2 --mode 3840x2160 --pos 0x0 --rotate normal --output DP-3 --off --output DP-4 --mode 1920x1080 --pos 3840x0 --rotate left --scale 2x2 --output DP-5 --off --output DP-6 --off
xrandr --output DP-0 --off --output DP-1 --off --output DP-2 --mode 3840x2160 --pos 0x0 --rotate normal --output DP-3 --off --output DP-4 --mode 1920x1080 --scale 2x2 --pos 3840x0 --rotate normal --output DP-5 --off --output DP-6 --off
	feh --bg-scale  /home/diegorenner/Pictures/wallpaper.jpg 
else
	feh --bg-scale /home/diegorenner/Pictures/wallpaper.jpg
fi
