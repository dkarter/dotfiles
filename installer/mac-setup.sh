#!/bin/bash

# symlink 1password ssh agent sock file so that the paths are compatible between
# mac and linux (linux uses the ~/.1password, and mac uses that ugly path below)
if [ ! -d "$HOME/.1password" ]; then
  echo 'Symlinking 1Password SSH Agent Sock'
  mkdir -p ~/.1password && ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock
fi

echo 'Disabling annoying features...'
# ------------------------------------
# disables the hold key menu to allow key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# The speed of repetition of characters
defaults write -g KeyRepeat -int 2

# Delay until repeat
defaults write -g InitialKeyRepeat -int 15

# Set dock to auto hide with no delay
defaults write com.apple.dock autohide -int 1
# ------------------------------------

if ! command -v brew &>/dev/null; then
  echo 'Homebrew not installed, installing...'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo 'Getting brew packages...'
brew bundle

if ! command -v sudo-touchid &>/dev/null; then
  echo 'Installing Sudo TouchID...'
  curl -# https://raw.githubusercontent.com/artginzburg/sudo-touchid/main/sudo-touchid.sh -o /usr/local/bin/sudo-touchid &&
    chmod +x /usr/local/bin/sudo-touchid &&
    sudo curl -# https://raw.githubusercontent.com/artginzburg/sudo-touchid/main/com.user.sudo-touchid.plist -o /Library/LaunchDaemons/com.user.sudo-touchid.plist &&
    /usr/local/bin/sudo-touchid
fi

# TODO: this requires XCode to be installed, maybe it can be added via `mas`
# CLI?
# NOTE: check this page if getting an error from xcodebuild:
# https://stackoverflow.com/questions/17980759/xcode-select-active-developer-directory-error
if ! command -v unicornleap &>/dev/null; then
  echo 'Installing unicornleap... (requires XCode)'
  mkdir -p ~/dev/forks

  # clone unicornleap
  rm -rf ~/dev/forks/unicornleap
  git clone --depth=1 git@github.com:jgdavey/unicornleap.git ~/dev/forks/unicornleap

  # create install dir
  mkdir ~/.bin

  # Install
  # shellcheck disable=2164
  pushd ~/dev/forks/unicornleap &&
    make &&
    make images &&
    cp build/unicornleap ~/.bin/ &&
    popd || exit
fi

# Install TerminalVim
if [[ ! -f "/Applications/TerminalVim.app" ]]; then
  echo 'Installing TerminalVim app'
  cp -r ./iterm/TerminalVim.app /Applications/TerminalVim.app
fi

if [[ ! -f "/Applications/BTop.app" ]]; then
  echo 'Installing BTop app'
  cp -r ./iterm/BTop.app /Applications/BTop.app
fi

# setup file handlers for TerminalVim
terminal_vim_id="$(osascript -e 'id of app "TerminalVim"')"
for ext in md txt js jsx ts tsx json lua rb ex exs eex heex yaml yml plist; do
  echo "Setting TerminalVim as handler for .$ext"
  duti -s "$terminal_vim_id" ".$ext" editor
done
