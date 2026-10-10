#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Dismiss Notifs
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔕
# @raycast.packageName dismiss-notifs

# Documentation:
# @raycast.description "Dismisses macOS notifications"
# @raycast.author dorian
# @raycast.authorURL https://raycast.com/dorian

osascript ./dismiss-notifications
