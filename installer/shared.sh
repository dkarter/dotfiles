#!/usr/bin/env bash

# TODO: move this to a task, including the script it runs
if ! infocmp tmux-256color >/dev/null 2>&1; then
  echo 'Installing TMux term info...'
  ./scripts/term.sh
fi
