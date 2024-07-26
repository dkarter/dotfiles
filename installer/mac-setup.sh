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

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Show battery percentage in menubar
defaults -currentHost write com.apple.controlcenter.plist BatteryShowPercentage -bool true

# change hammerspoon config dir to XDG Home:
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"

# ------------------------------------
if [ "$(hidutil property --get 'UserKeyMapping')" == '(null)' ]; then
  echo 'Remapping macOS modifiers...'
  # remap CapsLock to Escape (now)
  ./scripts/remap_macos_modifiers.sh

  # remap CapsLock to Escape (survives system restarts)
  # this was generated using https://hidutil-generator.netlify.app/
  PLIST_TARGET="$HOME/Library/LaunchAgents/com.local.KeyRemapping.plist"

  if [ ! -f "$PLIST_TARGET" ]; then
    sudo cp ./macos/com.local.KeyRemapping.plist "$PLIST_TARGET"
  fi
fi

# install homebrew
if ! command -v brew &>/dev/null; then
  echo 'Homebrew not installed, installing...'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo 'Setting up App Shortcuts...'

# ^ for Control, @ for Command, $ for shift
set_app_shortcut() {
  defaults write "$1" NSUserKeyEquivalents -dict-add "$2" "$3"
}

# WezTerm bundle identifier
# got it using `mdls -name kMDItemCFBundleIdentifier -r /Applications/WezTerm.app`
app_id='com.github.wez.wezterm'

# these can be set on the UI and then read to replicate using the following
# command: `defaults read com.github.wez.wezterm NSUserKeyEquivalents`

# Disable default shortcuts for tabs in wezterm
set_app_shortcut "$app_id" 'Activate the tab to the left' '\0'
set_app_shortcut "$app_id" 'Activate the tab to the right' '\0'

echo 'Getting brew packages...'
brew bundle

# NOTE: check this page if getting an error from xcodebuild:
# https://stackoverflow.com/questions/17980759/xcode-select-active-developer-directory-error
if ! command -v unicornleap &>/dev/null; then
  echo 'Installing unicornleap... (requires XCode)'
  # install full xcode (required for unicorn)
  mas install 497799835

  # accept license
  sudo xcodebuild -license

  # finish Xcode setup
  xcodebuild -runFirstLaunch

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
