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
      if [ -f /etc/lsb-release ]; then
        DIST=$(grep '^DISTRIB_ID' </etc/lsb-release | awk -F= '{ print $2 }')
      fi
    elif [[ $(uname -r) =~ arch1 ]]; then
      DISTRO_BASE='arch'
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

if [[ $OS == 'mac' ]]; then
  echo 'macOS detected'
  bash ./installer/mac-setup.sh
fi

if [[ $DISTRO_BASE == 'debian' ]]; then
  echo 'Debian-based Linux detected'
  bash ./installer/debian-setup.sh
fi

echo 'Installing shared steps...'
bash ./installer/shared.sh

if [[ ! -f ~/.local/bin/task ]]; then
  # Install task
  mkdir -p ~/.local/bin
  sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin
fi

export PATH="$PATH:$HOME/.local/bin"

# Run task
if [[ ${DEVPOD:-} == 'true' || ${DEVCONTAINER:-} == 'true' ]]; then
  task dot:install:devpod "$@"
else
  task install "$@"
fi
