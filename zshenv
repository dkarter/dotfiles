# ensure dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# mkdir .git/safe in the root of repositories you trust
export PATH=".git/safe/../../bin:$PATH"

# caching the brew prefix to speed up zshrc initialization
export BREW_PREFIX="/usr/local"

# Local config
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
