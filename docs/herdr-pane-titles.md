# Herdr pane titles

`config/zsh/herdr.zsh` labels a Herdr pane while a mapped command is running and clears the label when the command returns to the shell prompt.

The current mappings are:

| Executable   | Pane title     |
| ------------ | -------------- |
| `claude`     | `󰚩 claude`     |
| `lazydocker` | ` lazydocker` |
| `lazygit`    | ` lazygit`    |
| `nvim`       | ` neovim`     |
| `opencode`   | ` opencode`   |
| `tuicr`      | ` tuicr`      |

The hooks are registered only when Zsh is running inside a Herdr pane. Unmapped commands perform a native Zsh map lookup without starting another process. Mapped title updates run asynchronously.

## Disable pane titles

Add this to `~/.zshrc.local`:

```zsh
export HERDR_DISABLE_PANE_TITLES=1
```

Any nonempty value disables automatic titles. Open a new shell after changing the setting, or reload the module in the current shell:

```zsh
source ~/.config/zsh/herdr.zsh
```

## Add a mapping

Add an executable and its label to `HERDR_PANE_TITLES` in `config/zsh/herdr.zsh`:

```zsh
typeset -gA HERDR_PANE_TITLES=(
  btop '󰄪 btop'
  nvim ' neovim'
)
```

Only directly mapped executables trigger a title update.
