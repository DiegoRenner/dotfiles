#!/bin/bash
touch /tmp/khal_dropdown_open
pkill -RTMIN+8 waybar

# Trap: leave the dismiss submap, restore terminal, clear flag, refresh waybar.
# Runs on every exit path (Esc/click via handler kill, toggle pkill, keypress).
trap 'hyprctl dispatch submap reset >/dev/null 2>&1; tput cnorm 2>/dev/null; tput rmcup 2>/dev/null; rm -f /tmp/khal_dropdown_open; pkill -RTMIN+8 waybar; exit 0' EXIT TERM INT HUP

# Alternate screen buffer, no scrollback/cutoff, hidden text cursor.
tput smcup
tput clear
tput cup 0 0
tput civis 2>/dev/null

# Print file without its trailing newline, then exactly one newline, then the footer.
cat /tmp/khal_cache_full.txt | head -c -1
echo -en "\n\e[90m(Click here for full calendar; click elsewhere or Esc to close)\e[0m"

# Enter the dismiss submap: any mouse click (taps included) and Escape are
# handled globally by khal_dropdown_click.sh — click inside opens the full
# calendar, anything else just closes; the mouse cursor keeps its normal
# shape (no overlay). NOTE: while the dropdown is open, other Hyprland
# keybinds are inactive (submaps replace the keymap); plain typing into the
# focused window is unaffected.
hyprctl dispatch submap khal_dropdown >/dev/null 2>&1

# Any key typed into the dropdown itself also closes it.
read -rs -n 1
exit 0
