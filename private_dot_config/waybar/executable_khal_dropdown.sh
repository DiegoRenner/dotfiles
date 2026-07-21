#!/bin/bash
# Hide the cursor
printf '\e[?25l'
cal="$(cat /tmp/khal_cache.txt 2>/dev/null || khal calendar)"
printf "%s" "$cal"
while IFS= read -rsn1 key; do
  # Exit on Esc, q, or Enter/EOF
  if [[ $key == $'\e' || $key == 'q' || $key == '' ]]; then
    break
  fi
done
