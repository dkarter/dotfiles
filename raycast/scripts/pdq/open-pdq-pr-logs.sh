#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title PDQ: Open Preview Env Logs
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📜
# @raycast.packageName pdq-preview-env

# Documentation:
# @raycast.description "PDQ: Open logs in GroundCover for the current Preview Env"
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

if [[ $url =~ ^https://github\.com/pdq/houston/pull/([0-9]+)([/?#].*)?$ ]]; then
  pr="${BASH_REMATCH[1]}"
elif [[ $url =~ ^https://app\.graphite\.com/github/pr/pdq/houston/([0-9]+)([/?#].*)?$ ]]; then
  pr="${BASH_REMATCH[1]}"
elif [[ $url =~ ^https://pr-([0-9]+)\.houston\.pdq\.tools(/.*)?$ ]]; then
  pr="${BASH_REMATCH[1]}"
else
  echo "Could not find PR number in URL"
  exit 1
fi

open "https://app.groundcover.com/logs?start=&end=&duration=Last+hour&src_cluster=staging&src_env=&backendId=groundcover&sortBy=timestamp&order=desc&selectedLogId=&selectedLogTimestamp=&fullVisibility=false&query=&filter_g_namespace=:%22houston-pr-$pr%22"
