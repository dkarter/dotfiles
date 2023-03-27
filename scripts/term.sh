#!/bin/bash

set -euxo pipefail

# download an updated terminfo file
mkdir /tmp/terminfo
pushd /tmp/terminfo
curl -LO https://invisible-island.net/datafiles/current/terminfo.src.gz && gunzip terminfo.src.gz
tic -xe alacritty-direct,tmux-256color terminfo.src
popd
