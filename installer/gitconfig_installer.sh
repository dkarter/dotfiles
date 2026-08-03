#!/bin/bash

set -euo pipefail

if ! command -v op &>/dev/null; then
  echo "Can't find 1Password CLI (op) in PATH. Install it and try again."
  exit 1
fi

# Install the user-specific GitHub identity and signing config from 1Password.
gitconfig_file="$HOME/.gitconfig.local"
allowed_signers_file="$HOME/.ssh/allowed_signers"
gitconfig_tmp=$(mktemp)

trap 'rm -f "$gitconfig_tmp"' EXIT

op read "op://Private/.gitconfig.local/file" >"$gitconfig_tmp"
chmod 600 "$gitconfig_tmp"
mv "$gitconfig_tmp" "$gitconfig_file"

signing_email=$(git config --file "$gitconfig_file" --get user.email || true)
signing_key=$(git config --file "$gitconfig_file" --get user.signingkey || true)

if [[ -z $signing_email || -z $signing_key ]]; then
  echo "Missing user.email or user.signingKey in $gitconfig_file"
  exit 1
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
touch "$allowed_signers_file"
chmod 600 "$allowed_signers_file"

signer_entry="$signing_email $signing_key"
if ! grep -Fqx -- "$signer_entry" "$allowed_signers_file"; then
  if [[ -s $allowed_signers_file && $(tail -c 1 "$allowed_signers_file" | wc -l) -eq 0 ]]; then
    printf '\n' >>"$allowed_signers_file"
  fi
  printf '%s\n' "$signer_entry" >>"$allowed_signers_file"
fi
