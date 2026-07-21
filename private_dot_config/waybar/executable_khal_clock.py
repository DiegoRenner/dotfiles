#!/usr/bin/env python3
import datetime
import json
import subprocess
import sys
import os

STATE_FILE = "/tmp/waybar_clock_state"

def get_khal_calendar():
    try:
        # Run khal calendar. It outputs 3 months and appointments
        res = subprocess.run(['khal', 'calendar'], capture_output=True, text=True, timeout=2)
        return res.stdout.rstrip()
    except Exception as e:
        return "Calendar output unavailable"

def toggle_state():
    state = "time"
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, "r") as f:
            state = f.read().strip()
    
    new_state = "date" if state == "time" else "time"
    with open(STATE_FILE, "w") as f:
        f.write(new_state)
    
    # We don't print anything on toggle, waybar will run the script again immediately if we use signals,
    # but with `custom`, `on-click` executes a command. We can just execute the toggle and then send SIGRTMIN
    # to waybar to update the module. But wait! `custom` module updates automatically if `on-click` finishes
    # IF `exec-on-event` is false? No, `custom` module only updates based on `interval` or signal.
    # Actually, we can just print the updated state directly here, but wait...
    # If `on-click` calls `--toggle`, it's a separate process. Waybar doesn't capture its output for the module.
    # We should send a signal to Waybar to refresh the module.

def get_state():
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, "r") as f:
            return f.read().strip()
    return "time"

def main():
    if len(sys.argv) > 1 and sys.argv[1] == "--toggle":
        toggle_state()
        # Find waybar process and send SIGRTMIN+8 (we will configure waybar to use signal 8)
        subprocess.run(['pkill', '-RTMIN+8', 'waybar'])
        return

    state = get_state()
    now = datetime.datetime.now()
    
    if state == "date":
        text = now.strftime("%Y-%m-%d")
    else:
        text = now.strftime("%H:%M")

    tooltip = get_khal_calendar()
    
    # Escape markup for waybar Pango formatting
    tooltip = tooltip.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
    
    print(json.dumps({
        "text": text,
        "tooltip": f"<tt>{tooltip}</tt>",
        "class": "custom-clock"
    }))

if __name__ == "__main__":
    main()
