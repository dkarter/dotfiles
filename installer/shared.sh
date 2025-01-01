#!/usr/bin/env bash

# TODO: move this to a task, including the script it runs
if [[ ! -f "/tmp/terminfo/terminfo.src" ]]; then
  echo 'Installing TMux term info...'
  ./scripts/term.sh
fi
