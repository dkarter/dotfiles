# HomeBrew Github API Token Placeholder
export HOMEBREW_GITHUB_API_TOKEN="<<-[[CHANGEINLOCALZSHRC]]->>"

if [ -d /home/linuxbrew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# disable analytics
export HOMEBREW_NO_ANALYTICS=1
