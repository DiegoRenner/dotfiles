#!/bin/bash

# Log file for debugging boot issues
LOGFILE="/tmp/hypr_set_wallpaper.log"
echo "--- $(date) Wallpaper script started ---" >"$LOGFILE"

# Start awww-daemon if not already running
if ! pgrep -x "awww-daemon" >/dev/null; then
  echo "Starting awww-daemon..." >>"$LOGFILE"
  awww-daemon &
fi

# Function to get the internal monitor name
get_internal_monitor() {
  hyprctl monitors -j | jq -r '.[] | select(.description | contains("BOE")) | .name'
}

# Wait for the internal monitor to be detected by hyprctl
MAX_RETRIES=20
RETRY_COUNT=0
INTERNAL_MONITOR=$(get_internal_monitor)

while [ -z "$INTERNAL_MONITOR" ] && [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  echo "Internal monitor not found by hyprctl. Retrying ($RETRY_COUNT/$MAX_RETRIES)..." >>"$LOGFILE"
  sleep 1
  INTERNAL_MONITOR=$(get_internal_monitor)
  ((RETRY_COUNT++))
done

if [ -z "$INTERNAL_MONITOR" ]; then
  echo "CRITICAL: Internal monitor NOT found after $MAX_RETRIES retries!" >>"$LOGFILE"
else
  echo "Found internal monitor: $INTERNAL_MONITOR" >>"$LOGFILE"
fi

# Explicitly wait for awww-daemon to be responsive
while ! awww query >/dev/null 2>&1; do
  echo "Waiting for awww-daemon to initialize..." >>"$LOGFILE"
  sleep 0.5
done

# Wait for awww to see the specific internal monitor output
# This is crucial in dedicated mode where it might take longer for awww to register the output
RETRY_COUNT=0
while ! awww query | grep -q "$INTERNAL_MONITOR" && [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  echo "Waiting for awww to detect output: $INTERNAL_MONITOR ($RETRY_COUNT/$MAX_RETRIES)..." >>"$LOGFILE"
  sleep 1
  ((RETRY_COUNT++))
done

# Final check of what awww sees
echo "Current awww outputs:" >>"$LOGFILE"
awww query >>"$LOGFILE" 2>&1

# Default wallpaper for all monitors
echo "Setting default wallpaper: /home/diego/.config/hypr/wallpapers/moon.jpg" >>"$LOGFILE"
awww img /home/diego/.config/hypr/wallpapers/moon.jpg >>"$LOGFILE" 2>&1

if [ -n "$INTERNAL_MONITOR" ]; then
  echo "Setting wallpaper for internal monitor: $INTERNAL_MONITOR" >>"$LOGFILE"
  # Use a slight delay here to ensure the previous command doesn't block
  sleep 0.2
  awww img -o "$INTERNAL_MONITOR" /home/diego/.config/hypr/wallpapers/earth_180.jpg >>"$LOGFILE" 2>&1
fi

# Set portrait moon for the external display
if hyprctl monitors -j | jq -r '.[] | .name' | grep -q "HDMI-A-1"; then
  echo "Setting portrait moon for external monitor HDMI-A-1" >>"$LOGFILE"
  sleep 0.2
  awww img -o "HDMI-A-1" /home/diego/.config/hypr/wallpapers/moon_portrait.jpg >>"$LOGFILE" 2>&1
fi

echo "--- $(date) Wallpaper script finished ---" >>"$LOGFILE"
