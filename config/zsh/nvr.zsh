# Editor Wrapper to support neovim-remote

# If not inside TMUX, just alias e to EDITOR, no need to all this roundabouts
[[ -z $TMUX ]] && alias e=$EDITOR && return 0

# Check if neovim is our editor of choice
[[ $EDITOR == *"nvim" ]] && __is_editor_nvim="yes"

# If we don't have nvim installed just alias e to $EDITOR and be done with it
[[ -z $__is_editor_nvim ]] && alias e=$EDITOR && return 0

# Check for NVR
(( $+commands[nvr] )) && __is_nvr_installed="yes"

# If we don't have NVR installed, just alias e to $EDITOR and be done with it
[[ -z $__is_nvr_installed ]] && alias e=$EDITOR && return 0

unalias e 2>/dev/null
unalias :e 2>/dev/null

# Let's export the $EDITOR and NVIM_LISTEN_ADDRESS to use nvr and the current
# session socket.
local __current_tmux_session="$(tmux display-message -p '#S')"
local __current_session_window="$(tmux display-message -p '#I')"
# Replace slashes on session name to prevent socket creation errors
__current_tmux_session="${__current_tmux_session//\//-}"
export NVIM_LISTEN_ADDRESS="/tmp/nvimsocket-${__current_tmux_session}-${__current_session_window}"

alias nvim="nvim --listen $NVIM_LISTEN_ADDRESS"

export EDITOR="nvr --servername $NVIM_LISTEN_ADDRESS"
export VISUAL="nvr --servername $NVIM_LISTEN_ADDRESS"

function e() {
  nvr --servername $NVIM_LISTEN_ADDRESS "$1" && tmux select-pane -l
}

# Elixir Editor Support
# -------------------------------------------
# (these are pretty naive.. they assume that the last pane is the one containing
# vim, but that may not be the case. The file should still open in the correct
# place, we just might not land on it at the end of the command. There is
# probably a better way to do that.)
# open exh source files in neovim in the last pane
# see https://github.com/rowlandcodes/exhelp#open-source-code-in-an-editor
export ELIXIR_EDITOR="$EDITOR +'__LINE__' __FILE__ && tmux select-pane -l"

# open ecto generated source files in neovim in the last pane
# see https://hexdocs.pm/ecto/Mix.Tasks.Ecto.Gen.Repo.html
# and https://hexdocs.pm/ecto_sql/Mix.Tasks.Ecto.Gen.Migration.html
export ECTO_EDITOR="$EDITOR +'__LINE__' __FILE__ && tmux select-pane -l"
