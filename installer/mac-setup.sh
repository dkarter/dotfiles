#!/bin/bash

# symlink 1password ssh agent sock file so that the paths are compatible between
# mac and linux (linux uses the ~/.1password, and mac uses that ugly path below)
if [ ! -d "$HOME/.1password" ]; then
  echo 'Symlinking 1Password SSH Agent Sock'
  mkdir -p ~/.1password && ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock
fi
