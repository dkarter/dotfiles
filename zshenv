# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# mkdir .git/safe in the root of repositories you trust
export PATH=".git/safe/../../bin:$PATH"

# caching the brew prefix to speed up zshrc initialization
if [[ $OSTYPE == darwin* ]]; then
  if [[ $MACHTYPE == arm64* ]]; then
    export BREW_PREFIX="/opt/homebrew"
  else
    export BREW_PREFIX="/usr/local"
  fi
fi

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
