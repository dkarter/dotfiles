#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Toggle kindaVim
# @raycast.mode compact
# @raycast.icon ⌨️
# @raycast.packageName kindaVim
# @raycast.description Enable kindaVim by launching it, or disable it by quitting it.

set -eu

if /usr/bin/pgrep -x kindaVim >/dev/null; then
  /usr/bin/osascript -e 'tell application id "mo.com.sleeplessmind.kindaVim" to quit'
  for ((attempt = 0; attempt < 30; attempt++)); do
    if ! /usr/bin/pgrep -x kindaVim >/dev/null; then
      echo "kindaVim disabled"
      exit 0
    fi
    /bin/sleep 0.1
  done
  echo "kindaVim did not quit" >&2
  exit 1
else
  /usr/bin/open -g -b mo.com.sleeplessmind.kindaVim
  for ((attempt = 0; attempt < 30; attempt++)); do
    if /usr/bin/pgrep -x kindaVim >/dev/null; then
      echo "kindaVim enabled"
      exit 0
    fi
    /bin/sleep 0.1
  done
  echo "kindaVim did not launch" >&2
  exit 1
fi
