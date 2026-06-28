#!/bin/bash

set -euxo pipefail

# download an updated terminfo file
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

mkdir -p ~/.terminfo/61 ~/.terminfo/74
pushd "$tmp_dir"
curl -fsSLO https://invisible-island.net/datafiles/current/terminfo.src.gz
gunzip terminfo.src.gz

if ! tic -xe alacritty-direct,tmux-256color terminfo.src; then
  echo 'Could not compile alacritty-direct; installing tmux-256color only.' >&2
  tic -xe tmux-256color terminfo.src
fi

popd
