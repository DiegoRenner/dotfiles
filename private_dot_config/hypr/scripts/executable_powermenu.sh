#!/bin/bash

# A rofi-based power menu that reacts to a single key press.

# The options to display in the menu.
# We're using a single string with newlines for the message.
options=" [S]hutdown\n [R]eboot\n S[u]spend\n [H]ibernate\n [L]ock\n L[o]gout"

# We pipe an empty string into rofi to make it open without any entries.
# -dmenu: Enables dmenu mode.
# -i: Makes matching case-insensitive.
# -p: Sets the prompt text.
# -mesg: Displays the options string as a message.
# -kb-custom-[n]: Binds a key to a custom action. When the key is pressed,
#                 rofi exits with a return code of 10 + n.
#                 For example, -kb-custom-1 (bound to 's') exits with code 10.
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" \
  -kb-custom-1 "s,S" \
  -kb-custom-2 "r,R" \
  -kb-custom-3 "u,U" \
  -kb-custom-4 "h,H" \
  -kb-custom-5 "l,L" \
  -kb-custom-6 "o,O")

# Get the exit code from the rofi command.
exit_code=$?

# A 'case' statement to perform an action based on the exit code.
# An exit code of 1 means the user pressed Esc and we should do nothing.
case $exit_code in
10) # Corresponds to -kb-custom-1 (s)
  systemctl poweroff
  ;;
11) # Corresponds to -kb-custom-2 (r)
  systemctl reboot
  ;;
12) # Corresponds to -kb-custom-3 (u)
  systemctl suspend
  ;;
13) # Corresponds to -kb-custom-4 (h)
  systemctl hibernate
  ;;
14) # Corresponds to -kb-custom-5 (l)
  swaylock
  ;;
15) # Corresponds to -kb-custom-6 (o)
  hyprctl dispatch exit
  ;;
esac

echo $chosen
# Execute the command based on the choice
case "$chosen" in
" [S]hutdown")
  systemctl poweroff
  ;;
" [R]eboot")
  systemctl reboot
  ;;
" S[u]spend")
  systemctl suspend
  ;;
" [H]ibernate")
  systemctl hibernate
  ;;
" [L]ock")
  swaylock
  ;;
" L[o]gout")
  hyprctl dispatch exit
  ;;
esac
