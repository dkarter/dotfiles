#!/usr/bin/env ruby

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title local
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 💻
# @raycast.argument1 { "type": "text", "placeholder": "port e.g. 3000" }
# @raycast.packageName DevTools

# Documentation:
# @raycast.description Open a localhost port on the browser
# @raycast.author dorian
# @raycast.authorURL https://raycast.com/dorian

system "open 'http://localhost:#{ARGV[0]}'"
