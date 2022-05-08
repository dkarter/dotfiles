#!/bin/bash

# DETECT OS
# Shamelessly copied from stackoverflow:
# https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
# =================================================================================
lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

OS=`lowercase \`uname\``
KERNEL=`uname -r`
MACH=`uname -m`

if [ "${OS}" = "darwin" ]; then
    OS='mac'
else
    OS=`uname`
    if [ "${OS}" = "Linux" ] ; then
        if [ -f /etc/debian_version ] ; then
            DISTRO_BASE='debian'
            DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
        fi
        if [ -f /etc/UnitedLinux-release ] ; then
            DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
        fi
        OS=`lowercase $OS`
        readonly OS
        readonly DIST
        readonly DISTRO_BASE
        readonly PSUEDONAME
        readonly REV
        readonly KERNEL
        readonly MACH
    fi

fi

echo
echo "==========================================="
echo $OS
echo $DISTRO_BASE
echo $DIST
echo $KERNEL
echo $MACH
echo "==========================================="
echo

if [[ $DISTRO_BASE = 'debian' ]] ; then
  echo "Debian based repo detected, getting required packages..."
  ./installer/debian-setup.sh
elif [[ $OS = 'mac' ]] ; then
  echo 'Mac detected'

  if ! command -v brew &> /dev/null; then
    echo 'Homebrew not installed, installing...'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  echo 'getting brew packges...'
  brew bundle
fi

ruby installer.rb


