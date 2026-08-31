# generates the colors variable used by ls (eza), tree (erd), fd, bfs, dust and many other tools.
if command -v vivid &>/dev/null; then
  vivid_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/vivid-tokyonight-night"
  vivid_executable=${commands[vivid]}
  if [[ ! -r $vivid_cache || $vivid_executable -nt $vivid_cache ]]; then
    mkdir -p "${vivid_cache:h}"
    vivid generate tokyonight-night >|"$vivid_cache"
  fi
  export LS_COLORS=$(<"$vivid_cache")
  unset vivid_cache vivid_executable
fi
