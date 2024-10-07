# --------------------------------------------
# BEGIN tmux-open-nvim
# --------------------------------------------
# add `ton` (tmux-open-nvim) to path
# https://github.com/trevarj/tmux-open-nvim#caveat
export PATH="$PATH:$HOME/.config/tmux/plugins/tmux-open-nvim/scripts"

# only run this inside tmux
if [[ -n $TMUX ]]; then
  # support for tmux open nvim
  export EDITOR="ton"
  export VISUAL="ton"

  function e() {
    ton "$1"
  }

  # Elixir Editor Support + tmux open nvim
  # -------------------------------------------

  # https://hexdocs.pm/iex/IEx.Helpers.html#open/1
  export ELIXIR_EDITOR="ton"

  # see https://hexdocs.pm/ecto/Mix.Tasks.Ecto.Gen.Repo.html
  # and https://hexdocs.pm/ecto_sql/Mix.Tasks.Ecto.Gen.Migration.html
  export ECTO_EDITOR="ton"
fi

# --------------------------------------------
# END tmux-open-nvim
# --------------------------------------------
