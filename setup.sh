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

echo 'Installing shared steps...'
./installer/shared.sh

if [[ $DISTRO_BASE = 'debian' ]]; then
  echo "Debian based distro detected, getting required packages..."
  ./installer/debian-setup.sh
elif [[ $OS = 'mac' ]]; then
  echo 'macOS detected'
  ./installer/mac-setup.sh
fi

task install "$@"
