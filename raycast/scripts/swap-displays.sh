#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Swap Displays
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName swap_displays

# Documentation:
# @raycast.description Swaps the display arrangement
# @raycast.author dorian
# @raycast.authorURL https://raycast.com/dorian

# Check if displayplacer is installed
if ! command -v displayplacer &>/dev/null; then
  echo "displayplacer is not installed. Installing now..."
  brew install displayplacer

  if [ $? -ne 0 ]; then
    echo "Failed to install displayplacer. Please install Homebrew and try again."
    echo 'To install Homebrew: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
  fi
fi

# Get current display arrangement
current_arrangement=$(displayplacer list | grep "Persistent screen id")

# Extract display IDs
display_ids=()
while read -r line; do
  if [[ $line =~ Persistent\ screen\ id:\ ([0-9A-F-]+) ]]; then
    display_ids+=("${BASH_REMATCH[1]}")
  fi
done <<<"$current_arrangement"

# Check if we have exactly two displays
if [ ${#display_ids[@]} -ne 2 ]; then
  echo "This script requires exactly two displays. Found ${#display_ids[@]} displays."
  exit 1
fi

# Get current arrangement details
arrangement=$(displayplacer list)
display1_info=$(echo "$arrangement" | grep -A 10 "${display_ids[0]}" | head -n 10)
display2_info=$(echo "$arrangement" | grep -A 10 "${display_ids[1]}" | head -n 10)

# Extract origin coordinates
if [[ $display1_info =~ origin\(([0-9-]+)/([0-9-]+)\) ]]; then
  display1_x="${BASH_REMATCH[1]}"
  display1_y="${BASH_REMATCH[2]}"
fi

if [[ $display2_info =~ origin\(([0-9-]+)/([0-9-]+)\) ]]; then
  display2_x="${BASH_REMATCH[1]}"
  display2_y="${BASH_REMATCH[2]}"
fi

# Extract resolution
if [[ $display1_info =~ res\(([0-9]+)/([0-9]+)\) ]]; then
  display1_width="${BASH_REMATCH[1]}"
  display1_height="${BASH_REMATCH[2]}"
fi

if [[ $display2_info =~ res\(([0-9]+)/([0-9]+)\) ]]; then
  display2_width="${BASH_REMATCH[1]}"
  display2_height="${BASH_REMATCH[2]}"
fi

# Determine which display is on the left
if [ "$display1_x" -lt "$display2_x" ]; then
  # Display 1 is on the left, Display 2 is on the right
  left_display="${display_ids[0]}"
  right_display="${display_ids[1]}"
  left_res="${display1_width}x${display1_height}"
  right_res="${display2_width}x${display2_height}"
  left_y="$display1_y"
  right_y="$display2_y"
else
  # Display 2 is on the left, Display 1 is on the right
  left_display="${display_ids[1]}"
  right_display="${display_ids[0]}"
  left_res="${display2_width}x${display2_height}"
  right_res="${display1_width}x${display1_height}"
  left_y="$display2_y"
  right_y="$display1_y"
fi

# Swap the displays
echo "Swapping display arrangement..."

# Calculate new positions
if [ "$left_display" = "${display_ids[0]}" ]; then
  # Move display 1 to the right and display 2 to the left
  displayplacer "id:${display_ids[0]} res:${left_res} origin:${display2_width},${left_y} degree:0" "id:${display_ids[1]} res:${right_res} origin:0,${right_y} degree:0"
else
  # Move display 2 to the right and display 1 to the left
  displayplacer "id:${display_ids[0]} res:${right_res} origin:0,${right_y} degree:0" "id:${display_ids[1]} res:${left_res} origin:${display1_width},${left_y} degree:0"
fi

echo "Display arrangement swapped successfully!"
