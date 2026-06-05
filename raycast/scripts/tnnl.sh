#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title tnnl
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🕳️
# @raycast.argument1 { "type": "text", "placeholder": "subdomain" }
# @raycast.packageName DevTools

# Documentation:
# @raycast.description Open a tnnl subdomain on the browser
# @raycast.author dorian
# @raycast.authorURL https://raycast.com/dorian

open "https://${1}.tnnl.me"
