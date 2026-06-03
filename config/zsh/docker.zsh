# Docker Compose's menu can fail under tmux with tmux-256color/termbox.
if [[ -n ${TMUX:-} ]]; then
  export COMPOSE_MENU=false
fi
