#!/bin/bash
# Script to toggle between current wallpaper and a blank (black) background

if awww query | grep -q "image:"; then
  # If an image is showing, clear to black
  awww clear 000000ff
else
  # If it's already blank (or something else), restore the last image
  awww restore
fi
