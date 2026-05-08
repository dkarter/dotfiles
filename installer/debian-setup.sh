#!/bin/bash

sudo apt update
# we install more packages in @taskfiles/debian.yml, but these are required for
# the initial taskfile install
sudo apt install -y \
  curl \
  gpg
