# HomeBrew Github API Token Placeholder
export HOMEBREW_GITHUB_API_TOKEN="<<-[[CHANGEINLOCALZSHRC]]->>"

if [ -d /home/linuxbrew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# disable analytics
export HOMEBREW_NO_ANALYTICS=1

# set homebrew on path (Intel)
export PATH="/usr/local/bin:$PATH"
# set homebrew on path (Apple Silicon) - should be first to override system bins
# (e.g. for updating zsh or bash)
export PATH="/opt/homebrew/bin:$PATH"
