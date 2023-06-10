#!/bin/bash

# DETECT OS
# Shamelessly copied from stackoverflow:
# https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
# =================================================================================
lowercase() {
  echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

OS="$(lowercase "$(uname)")"
KERNEL="$(uname -r)"
MACH="$(uname -m)"

if [ "${OS}" = "darwin" ]; then
  OS='mac'
else
  OS="$(uname)"
  if [ "${OS}" = "Linux" ]; then
    if [ -f /etc/debian_version ]; then
      DISTRO_BASE='debian'
      DIST=$(grep '^DISTRIB_ID' </etc/lsb-release | awk -F= '{ print $2 }')
    fi
    if [ -f /etc/UnitedLinux-release ]; then
      DIST="${DIST}[$(tr "\n" ' ' </etc/UnitedLinux-release | sed s/VERSION.*//)]"
    fi
    OS="$(lowercase "$OS")"
    readonly OS
    readonly DIST
    readonly DISTRO_BASE
    readonly KERNEL
    readonly MACH
  fi

fi

echo
echo "==========================================="
echo "$OS"
echo "$DISTRO_BASE"
echo "$DIST"
echo "$KERNEL"
echo "$MACH"
echo "==========================================="
echo

if [[ $DISTRO_BASE = 'debian' ]]; then
  echo "Debian based distro detected, getting required packages..."
  ./installer/debian-setup.sh
elif [[ $OS = 'mac' ]]; then
  echo 'macOS detected'
  ./installer/mac-setup.sh

  echo 'Disabling annoying features...'
  # disables the hold key menu to allow key repeat
  defaults write -g ApplePressAndHoldEnabled -bool false
  # The speed of repetition of characters
  defaults write -g KeyRepeat -int 2
  # Delay until repeat
  defaults write -g InitialKeyRepeat -int 15

  if ! command -v brew &>/dev/null; then
    echo 'Homebrew not installed, installing...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  echo 'getting brew packages...'
  brew bundle

  # Install TerminalVim
  cp -r ./iterm/TerminalVim.app /Applications/

  # setup file handlers for TerminalVim
  terminal_vim_id="$(osascript -e 'id of app "TerminalVim"')"
  for ext in md txt js ts json lua rb ex exs eex heex; do
    echo "Setting TerminalVim as handler for .$ext"
    duti -s "$terminal_vim_id" ".$ext" all
  done
fi

ruby installer.rb
