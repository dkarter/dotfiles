# Television shell integration

function zvm_after_init() {
  # Initialize television shell integration after vi-mode
  eval "$(tv init zsh)"
  # zsh-vi-mode needs to rebind ctrl-r to make it available in normal mode
  # (vicmd)
  # https://github.com/jeffreytse/zsh-vi-mode/issues/242
  zvm_bindkey vicmd "^R" tv-shell-history
}
