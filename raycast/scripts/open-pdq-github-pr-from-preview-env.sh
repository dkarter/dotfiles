#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title PDQ: Open GitHub PR from Preview Env
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔗
# @raycast.packageName houston-preview-to-pr

# Documentation:
# @raycast.description Open the GitHub Pull Request (PR) from a Preview Env
# @raycast.author dorian
# @raycast.authorURL https://raycast.com/dorian

set -euo pipefail

front_asn=$(lsappinfo front)
front_app=$(lsappinfo info -only name "$front_asn" | sed -En 's/.*"LSDisplayName"="([^"]+)".*/\1/p')

case "$front_app" in
  "Zen Browser") browser="Zen" ;;
  "Zen" | "Helium") browser="$front_app" ;;
  *)
    echo "Frontmost app must be Zen or Helium"
    exit 1
    ;;
esac

if [ "$browser" = "Helium" ]; then
  url=$(osascript -e 'tell application "Helium" to get URL of active tab of front window')
else
  url=$(
    osascript <<'APPLESCRIPT'
set savedClipboard to the clipboard

tell application "Zen" to activate
delay 0.15

tell application "System Events"
  keystroke "l" using command down
  delay 0.1
  keystroke "c" using command down
end tell

delay 0.1
set currentURL to the clipboard as text
set the clipboard to savedClipboard

return currentURL
APPLESCRIPT
  )
fi

if [[ $url =~ ^https://pr-([0-9]+)\.houston\.pdq\.tools(/.*)?$ ]]; then
  pr="${BASH_REMATCH[1]}"
  open "https://github.com/pdq/houston/pull/$pr"
else
  echo "Could not find Preview Env PR number in URL"
  exit 1
fi
