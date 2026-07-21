#!/usr/bin/env python3
import datetime
import json
import subprocess
import sys
import os
import time

STATE_FILE = "/tmp/waybar_clock_state"
LAST_CLICK_FILE = "/tmp/waybar_clock_last_click"

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
        try:
            with open(STATE_FILE, "r") as f:
                state = f.read().strip()
        except Exception:
            state = "time"
    
    new_state = "date" if state == "time" else "time"
    try:
        with open(STATE_FILE, "w") as f:
            f.write(new_state)
    except Exception:
        pass

def handle_click():
    now = time.time()
    last_click = 0.0
    if os.path.exists(LAST_CLICK_FILE):
        try:
            with open(LAST_CLICK_FILE, "r") as f:
                last_click = float(f.read().strip())
        except Exception:
            pass

    with open(LAST_CLICK_FILE, "w") as f:
        f.write(str(now))

    if (now - last_click) < 0.4:
        # Double click: revert the first click toggle and launch interactive calendar
        toggle_state()
        subprocess.Popen(['alacritty', '--class', 'khal_calendar', '-e', 'khal', 'interactive'])
        subprocess.run(['pkill', '-RTMIN+8', 'waybar'])
    else:
        # Single click: toggle time/date display
        toggle_state()
        subprocess.run(['pkill', '-RTMIN+8', 'waybar'])

def get_state():
    if os.path.exists(STATE_FILE):
        try:
            with open(STATE_FILE, "r") as f:
                return f.read().strip()
        except Exception:
            pass
    return "time"

def main():
    if len(sys.argv) > 1 and (sys.argv[1] == "--toggle" or sys.argv[1] == "--click"):
        handle_click()
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
