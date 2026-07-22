#!/usr/bin/env python3
import datetime
import json
import subprocess
import sys
import os
import time

STATE_FILE = "/tmp/waybar_clock_state"
LAST_CLICK_FILE = "/tmp/waybar_clock_last_click"
TOOLTIP_STATE_FILE = "/tmp/waybar_tooltip_state"

def get_khal_calendar():
    try:
        with open('/tmp/khal_cache.txt', 'r') as f:
            return f.read().rstrip()
    except Exception:
        return "Calendar cache unavailable"

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

def toggle_tooltip_state():
    state = "hidden"
    if os.path.exists(TOOLTIP_STATE_FILE):
        try:
            with open(TOOLTIP_STATE_FILE, "r") as f:
                state = f.read().strip()
        except Exception:
            pass
    
    new_state = "visible" if state == "hidden" else "hidden"
    try:
        with open(TOOLTIP_STATE_FILE, "w") as f:
            f.write(new_state)
    except Exception:
        pass

def handle_click():
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

def show_dropdown_alacritty():
    # Toggle behavior: if it's running, kill it and return
    res = subprocess.run(['pgrep', '-f', 'alacritty --class khal_dropdown'], capture_output=True)
    if res.returncode == 0:
        subprocess.run(['pkill', '-f', 'alacritty --class khal_dropdown'])
        return

    # Dynamically calculate height and width based on cache contents
    try:
        with open('/tmp/khal_cache.txt', 'r') as f:
            lines = f.readlines()
            num_lines = len(lines)
            max_len = max(len(line.rstrip('\n')) for line in lines) if lines else 59
    except Exception:
        num_lines = 15
        max_len = 59
    
    # 15 lines fits perfectly in 320px (20px per line)
    calc_height = 320 + (num_lines - 15) * 20

    # Calculate width based on ~9 pixels per character plus padding
    calc_width = 40 + int(max_len * 9.5)
    # Cap width between 350px and 900px
    calc_width = max(350, min(calc_width, 900))

    x_pos = 1350
    try:
        monitors_out = subprocess.run(['hyprctl', 'monitors', '-j'], capture_output=True, text=True).stdout
        monitors = json.loads(monitors_out)
        for m in monitors:
            if m.get("focused"):
                logical_width = m["width"] / m["scale"]
                x_pos = int(logical_width - calc_width - 20)
                break
    except Exception:
        pass

    # Use hyprctl to spawn a floating alacritty window at the top right
    cmd = [
        'hyprctl', 'dispatch', 'exec',
        f"[float; size {calc_width} {calc_height}; move {x_pos} 40; pin] alacritty --class khal_dropdown -e /home/diego/.config/waybar/khal_dropdown.sh"
    ]
    subprocess.Popen(cmd)

def main():
    if len(sys.argv) > 1:
        arg = sys.argv[1]
        if arg == "--right-click":
            show_dropdown_alacritty()
            return
        elif arg == "--toggle" or arg == "--click":
            handle_click()
            return

    # Background update for the calendar cache to make the dropdown instant
    subprocess.Popen("khal calendar today 7d > /tmp/khal_cache.txt.tmp && mv /tmp/khal_cache.txt.tmp /tmp/khal_cache.txt", shell=True)

    state = get_state()
    now = datetime.datetime.now()
    
    if state == "date":
        text = now.strftime("%Y-%m-%d")
    else:
        text = now.strftime("%H:%M")
    
    print(json.dumps({
        "text": text,
        "class": "custom-clock"
    }))

if __name__ == "__main__":
    main()
