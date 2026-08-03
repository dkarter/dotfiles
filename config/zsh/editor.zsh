export EDITOR="nvim"
export VISUAL="nvim"
# this is a fix because elixir editors need to be opened in a separate window
# see https://github.com/elixir-ecto/ecto/issues/1581#issuecomment-233126107
export ELIXIR_EDITOR='nvim-sibling-pane "__FILE__" __LINE__'
export PLUG_EDITOR="$ELIXIR_EDITOR"
export ECTO_EDITOR="$ELIXIR_EDITOR"
