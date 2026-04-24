#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Wallpaper
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🌠
# @raycast.packageName Wallpaper Doodad

# Documentation:
# @raycast.description Toggles Wallpaper from image to solid black and back
# @raycast.author dorian
# @raycast.authorURL https://raycast.com/dorian

# Set the desktop background to the built-in solid black wallpaper

# Path to store the current wallpaper location
WALLPAPER_PATH_FILE="$HOME/tmp/.current_wallpaper_path"

# Path to the solid black wallpaper
BLACK_WALLPAPER="/System/Library/Desktop Pictures/Solid Colors/Black.png"

# Function to get the current wallpaper path
get_current_wallpaper() {
  osascript -e 'tell application "System Events" to get picture of first desktop'
}

# Function to set wallpaper
set_wallpaper() {
  local path=$1
  osascript -e "tell application \"System Events\" to set picture of every desktop to \"$path\""
}

# Check if the wallpaper path file exists and read the path
if [ -f "$WALLPAPER_PATH_FILE" ]; then
  SAVED_WALLPAPER=$(cat "$WALLPAPER_PATH_FILE")

  # Set wallpaper to black and save current wallpaper path
  CURRENT_WALLPAPER=$(get_current_wallpaper)
  if [ "$CURRENT_WALLPAPER" != "$BLACK_WALLPAPER" ]; then
    echo "$CURRENT_WALLPAPER" >"$WALLPAPER_PATH_FILE"
    set_wallpaper "$BLACK_WALLPAPER"
  else
    set_wallpaper "$SAVED_WALLPAPER"
    rm "$WALLPAPER_PATH_FILE"
  fi
else
  # Save current wallpaper path and set to black
  CURRENT_WALLPAPER=$(get_current_wallpaper)
  echo "$CURRENT_WALLPAPER" >"$WALLPAPER_PATH_FILE"
  set_wallpaper "$BLACK_WALLPAPER"
fi
