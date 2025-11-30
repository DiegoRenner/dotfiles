#!/usr/bin/env bash

# Get the current internal fullscreen state (0 = Tiled, 1 = Max, 2 = Full)
current_state=$(hyprctl activewindow -j | jq '.fullscreen')
current_state_client=$(hyprctl activewindow -j | jq '.fullscreenClient')

if [[ "$current_state" == "2" || "$current_state" == "3" ]]; then
  # If currently Global Fullscreen -> Switch to Tiled (0) but Force Client Full (2)
  hyprctl dispatch fullscreenstate 0 -1
  current_state_after=$(hyprctl activewindow -j | jq '.fullscreen')
  current_state_client_after=$(hyprctl activewindow -j | jq '.fullscreenClient')
else
  # If currently Tiled -> Switch to Global Fullscreen (2) and Force Client Full (2)
  hyprctl dispatch fullscreenstate 2 -1
  current_state_after=$(hyprctl activewindow -j | jq '.fullscreen')
  current_state_client_after=$(hyprctl activewindow -j | jq '.fullscreenClient')
fi
notify-send -u low -t 2000 "from: $current_state $current_state_client to: $current_state_after $current_state_client_after"
