#!/bin/bash

# symlink 1password ssh agent sock file so that the paths are compatible between
# mac and linux (linux uses the ~/.1password, and mac uses that ugly path below)
if [ ! -d "$HOME/.1password" ]; then
  echo 'Symlinking 1Password SSH Agent Sock'
  mkdir -p ~/.1password && ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock
fi

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

echo 'Getting brew packages...'
brew bundle

echo 'Starting services...'
sudo brew services start sudo-touchid
sudo-touchid

# Install TerminalVim
echo 'Installing TerminalVim app'
cp -r ./iterm/TerminalVim.app /Applications/TerminalVim.app

echo 'Installing BTop app'
cp -r ./iterm/BTop.app /Applications/BTop.app

# setup file handlers for TerminalVim
terminal_vim_id="$(osascript -e 'id of app "TerminalVim"')"
for ext in md txt js ts json lua rb ex exs eex heex; do
  echo "Setting TerminalVim as handler for .$ext"
  duti -s "$terminal_vim_id" ".$ext" all
done
