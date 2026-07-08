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

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd -- "$script_dir/../.." && pwd)"

"$dotfiles_dir/scripts/swap-displays.sh" "$@"
