#!/bin/bash

if ! command -v op &>/dev/null; then
  echo "Can't find 1Password CLI (op) in PATH. Install it and try again."
  exit 1
fi

# This will install the Github + signing info from 1password
op read "op://Private/.gitconfig.local/file" >~/.gitconfig.local
