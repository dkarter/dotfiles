# Editor Wrapper to support neovim-remote

# If not inside TMUX, just alias e to EDITOR, no need to all this roundabouts
[[ -z $TMUX ]] && alias e=$EDITOR && return 0

unalias e 2>/dev/null
unalias :e 2>/dev/null

# Let's export the $EDITOR and NVIM_LISTEN_ADDRESS to use nvr and the current
# session socket.
# local __current_tmux_session="$(tmux display-message -p '#S')"
# local __current_session_window="$(tmux display-message -p '#I')"
# # Replace slashes on session name to prevent socket creation errors
# __current_tmux_session="${__current_tmux_session//\//-}"
# local __listen_address="/tmp/nvimsocket-${__current_tmux_session}-${__current_session_window}"
#
# alias nvim="nvim --listen $__listen_address"
#
# export EDITOR="nvr --servername $__listen_address"
# export VISUAL="nvr --servername $__listen_address"

export EDITOR="ton"
export VISUAL="ton"

function e() {
  # TODO: select the pane containing neovim instead of last pane
  # && tmux select-pane -l
  # nvr --servername $__listen_address "$1"
  ton "$1"
}

# Elixir Editor Support
# -------------------------------------------
# (these are pretty naive.. they assume that the last pane is the one containing
# vim, but that may not be the case. The file should still open in the correct
# place, we just might not land on it at the end of the command. There is
# probably a better way to do that.)
# open exh source files in neovim in the last pane
# see https://github.com/rowlandcodes/exhelp#open-source-code-in-an-editor
# --nostart is an arg to nvr - neovim can't start inside an interactive iex
# shell so it was hanging
# -s is an argument to nvr - to tell it not to show the warning when the server
# doesn't exist
# export ELIXIR_EDITOR="$EDITOR --nostart -s +'__LINE__' __FILE__"
export ELIXIR_EDITOR="ton"

# open ecto generated source files in neovim in the last pane
# see https://hexdocs.pm/ecto/Mix.Tasks.Ecto.Gen.Repo.html
# and https://hexdocs.pm/ecto_sql/Mix.Tasks.Ecto.Gen.Migration.html
# --nostart is an arg to nvr - neovim can't start inside an interactive iex
# shell so it was hanging
# -s is an argument to nvr - to tell it not to show the warning when the server
# doesn't exist
# export ECTO_EDITOR="$EDITOR --nostart -s +'__LINE__' __FILE__"
export ECTO_EDITOR="ton"
