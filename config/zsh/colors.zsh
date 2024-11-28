# generates the colors variable used by ls (eza), tree (erd), fd, bfs, dust and many other tools.
if command -v vivid &>/dev/null; then
  export LS_COLORS=$(vivid generate tokyonight-night)
fi
