#!/usr/bin/env bash

# Banner text (as array of lines for character-by-character coloring)
banner_lines=(
  "▓█▀▄ █▀█ █▀█ █ ▄▀█ █▄ █ ▀ █▀"
  "▒█▄▀ █▄█ █▀▄ █ █▀█ █ ▀█   ▄█"
  ""
  "▓█▀▄ █▀█ ▀█▀ █▀▀ █ █   █▀▀ █▀"
  "▒█▄▀ █▄█  █  █▀  █ █▄▄ ██▄ ▄█"
)

# Get the longest line length
max_len=0
for line in "${banner_lines[@]}"; do
  len=${#line}
  ((len > max_len)) && max_len=$len
done

# Spotlight parameters
frames=20

# Hide cursor
tput civis

# Animation loop
for ((frame = 0; frame < frames; frame++)); do
  # Calculate spotlight center position
  center=$((frame * max_len / frames))

  # Move cursor to top
  tput cup 0 0

  # Render each line
  for line in "${banner_lines[@]}"; do
    output=""
    if [[ -z $line ]]; then
      # Empty line
      echo -e "\033[K"
    else
      for ((i = 0; i < ${#line}; i++)); do
        char="${line:i:1}"
        # Calculate distance from spotlight center
        dist=$((i - center))
        dist=${dist#-} # absolute value

        # Calculate brightness based on distance (soft edges)
        if ((dist == 0)); then
          brightness=255
        elif ((dist == 1)); then
          brightness=252
        elif ((dist == 2)); then
          brightness=248
        elif ((dist == 3)); then
          brightness=244
        elif ((dist == 4)); then
          brightness=240
        else
          brightness=236
        fi

        output+="\033[38;5;${brightness}m${char}"
      done
      echo -e "${output}\033[0m\033[K"
    fi
  done

  sleep 0.05
done

# Final display - move cursor to top and show full brightness
tput cup 0 0
for line in "${banner_lines[@]}"; do
  echo "${line}"
done

# Show cursor again
tput cnorm
