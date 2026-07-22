#!/bin/bash
# Invoked by the khal_dropdown Hyprland submap on any mouse click ("click")
# or Escape ("esc") while the waybar calendar dropdown is open.
# Always restore the normal keymap FIRST so a wedged submap can never persist
# (any click self-heals it even if the dropdown died uncleanly).
hyprctl dispatch submap reset >/dev/null 2>&1

info=$(hyprctl clients -j 2>/dev/null | jq -r \
    '.[] | select(.class == "khal_dropdown") | "\(.pid) \(.at[0]) \(.at[1]) \(.size[0]) \(.size[1])"' | head -1)
[ -n "$info" ] || exit 0
read -r pid x y w h <<< "$info"

if [ "$1" = "click" ]; then
    pos=$(hyprctl cursorpos 2>/dev/null)
    cx=${pos%%,*}; cx=${cx%%.*}
    cy=${pos#*, }; cy=${cy%% *}; cy=${cy%%.*}
    ok=1
    case "$cx" in ''|*[!0-9-]*) ok=0 ;; esac
    case "$cy" in ''|*[!0-9-]*) ok=0 ;; esac
    if [ "$ok" = 1 ] && [ "$cx" -ge "$x" ] && [ "$cx" -lt $((x + w)) ] && \
       [ "$cy" -ge "$y" ] && [ "$cy" -lt $((y + h)) ]; then
        # Click inside the dropdown -> open the full interactive calendar
        # as a regular tiled window.
        hyprctl dispatch exec "alacritty --class khal_calendar -e khal interactive" >/dev/null 2>&1
    fi
fi

# Whether inside (calendar opened) or outside/esc: close the dropdown.
kill "$pid" 2>/dev/null
exit 0
