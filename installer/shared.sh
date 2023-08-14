#!/usr/bin/env bash

if [[ ! -f "/tmp/terminfo/terminfo.src" ]]; then
  echo 'Installing TMux term info...'
  ./scripts/term.sh
fi

# asdf and Ruby are installed from here because the install script uses features
# of ruby that don't exist on the pre-installed version bundled with the OS
if ! command -v asdf &>/dev/null; then
  echo "Installing ASDF"
  git clone git@github.com:asdf-vm/asdf.git ~/.asdf
  # shellcheck disable=1091
  source "$HOME/.asdf/asdf.sh"
  asdf plugin add ruby
  asdf install ruby latest
  asdf global ruby latest
fi
