#!/bin/bash

# Log file for debugging boot issues
LOGFILE="/tmp/hypr_set_wallpaper.log"
echo "--- $(date) Wallpaper script started ---" > "$LOGFILE"

# Start swww-daemon if not already running
if ! pgrep -x "swww-daemon" >/dev/null; then
  echo "Starting swww-daemon..." >> "$LOGFILE"
  swww-daemon &
  
  # Wait for the daemon to initialize
  while ! swww query >/dev/null 2>&1; do
    echo "Waiting for swww-daemon to initialize..." >> "$LOGFILE"
    sleep 0.5
  done
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
  echo "Internal monitor not found by hyprctl. Retrying ($RETRY_COUNT/$MAX_RETRIES)..." >> "$LOGFILE"
  sleep 0.5
  INTERNAL_MONITOR=$(get_internal_monitor)
  ((RETRY_COUNT++))
done

if [ -z "$INTERNAL_MONITOR" ]; then
  echo "CRITICAL: Internal monitor NOT found after $MAX_RETRIES retries!" >> "$LOGFILE"
else
  echo "Found internal monitor: $INTERNAL_MONITOR" >> "$LOGFILE"
fi

# Wait for swww to see the monitors
RETRY_COUNT=0
while ! swww query | grep -q "$INTERNAL_MONITOR" && [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  echo "Waiting for swww to detect output: $INTERNAL_MONITOR ($RETRY_COUNT/$MAX_RETRIES)..." >> "$LOGFILE"
  sleep 0.5
  ((RETRY_COUNT++))
done

# Default wallpaper for all monitors
echo "Setting default wallpaper: /home/diego/downloads/8642900.gif" >> "$LOGFILE"
swww img /home/diego/downloads/8642900.gif >> "$LOGFILE" 2>&1

if [ -n "$INTERNAL_MONITOR" ]; then
  echo "Setting wallpaper for internal monitor: $INTERNAL_MONITOR" >> "$LOGFILE"
  swww img -o "$INTERNAL_MONITOR" /home/diego/downloads/2825704.gif >> "$LOGFILE" 2>&1
fi

echo "--- $(date) Wallpaper script finished ---" >> "$LOGFILE"
