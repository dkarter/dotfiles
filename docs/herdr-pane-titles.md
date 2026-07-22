# Herdr pane titles

`config/zsh/herdr.zsh` labels a Herdr pane while a mapped command is running and clears the label when the command returns to the shell prompt.

The current mappings are:

| Executable   | Pane title     |
| ------------ | -------------- |
| `btop`       | `󰄪 btop`       |
| `claude`     | `󰚩 claude`     |
| `diffnav`    | ` diffnav`    |
| `dive`       | ` dive`       |
| `fx`         | ` fx`         |
| `gh`         | ` github`     |
| `kdash`      | `󱃾 kdash`      |
| `lazydocker` | ` lazydocker` |
| `lazygit`    | ` lazygit`    |
| `nvim`       | ` neovim`     |
| `opencode`   | ` opencode`   |
| `pi`         | `󰏿 pi`         |
| `posting`    | `󰒊 posting`    |
| `pspg`       | ` pspg`       |
| `tuicr`      | ` tuicr`      |
| `tv`         | ` television` |
| `yazi`       | ` yazi`       |

The hooks are registered only when Zsh is running inside a Herdr pane. Unmapped commands perform a native Zsh map lookup without starting another process. Mapped title updates run asynchronously.

## Performance

Benchmarks used Zsh 5.9.2 on Apple Silicon and repeated each path with Hyperfine:

| Path                          | Measured overhead       |
| ----------------------------- | ----------------------- |
| Outside Herdr                 | No per-command overhead |
| Unmapped command inside Herdr | About 9 microseconds    |
| Starting a mapped command     | About 1.3 milliseconds  |
| Clearing a mapped title       | About 1.3 milliseconds  |

A full mapped command cycle adds about 2.6 milliseconds, split between starting the command and returning to the prompt. The real Herdr CLI had effectively the same blocking cost as a no-op executable because title updates run in the background.

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
