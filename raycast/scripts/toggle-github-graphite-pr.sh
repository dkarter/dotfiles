#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle GitHub/Graphite PR
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔀
# @raycast.packageName pdq-pr-toggle

# Documentation:
# @raycast.description Toggle the current PR page between GitHub and Graphite
# @raycast.author dorian
# @raycast.authorURL https://raycast.com/dorian

set -euo pipefail

front_asn=$(lsappinfo front)
front_app=$(lsappinfo info -only name "$front_asn" | sed -En 's/.*"LSDisplayName"="([^"]+)".*/\1/p')

case "$front_app" in
  "Zen Browser")
    browser="Zen"
    ;;
  "Zen" | "Helium")
    browser="$front_app"
    ;;
  *)
    echo "Frontmost app must be Zen or Helium"
    exit 1
    ;;
esac

if [ "$browser" = "Helium" ]; then
  current_url=$(osascript -e 'tell application "Helium" to get URL of active tab of front window')
else
  current_url=$(
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

if [[ $current_url =~ ^https://github\.com/([^/]+)/([^/]+)/pull/([0-9]+)([/?#].*)?$ ]]; then
  owner="${BASH_REMATCH[1]}"
  repo="${BASH_REMATCH[2]}"
  pr="${BASH_REMATCH[3]}"
  target_url="https://app.graphite.com/github/pr/$owner/$repo/$pr"
elif [[ $current_url =~ ^https://app\.graphite\.com/github/pr/([^/]+)/([^/]+)/([0-9]+)([/?#].*)?$ ]]; then
  owner="${BASH_REMATCH[1]}"
  repo="${BASH_REMATCH[2]}"
  pr="${BASH_REMATCH[3]}"
  target_url="https://github.com/$owner/$repo/pull/$pr"
else
  echo "Current URL is not a supported GitHub or Graphite PR URL"
  exit 1
fi

if [ "$browser" = "Helium" ]; then
  osascript -e "tell application \"Helium\" to set URL of active tab of front window to \"$target_url\""
else
  TARGET_URL="$target_url" osascript <<'APPLESCRIPT'
set targetURL to system attribute "TARGET_URL"
set savedClipboard to the clipboard
set the clipboard to targetURL

tell application "Zen" to activate
delay 0.15

tell application "System Events"
  keystroke "l" using command down
  delay 0.1
  keystroke "v" using command down
  delay 0.05
  key code 36
end tell

delay 0.1
set the clipboard to savedClipboard
APPLESCRIPT
fi
