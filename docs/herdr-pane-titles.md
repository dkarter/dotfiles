# Herdr pane titles

`config/zsh/herdr.zsh` labels a Herdr pane while a mapped command is running and clears the label when the command returns to the shell prompt.

The current mappings are:

| Executable   | Pane title     |
| ------------ | -------------- |
| `amp`        | ` amp`        |
| `btop`       | `󰄪 btop`       |
| `claude`     | ` claude`     |
| `cline`      | ` cline`      |
| `codex`      | ` codex`      |
| `copilot`    | ` copilot`    |
| `cursor`     | ` cursor`     |
| `diffnav`    | ` diffnav`    |
| `dive`       | ` dive`       |
| `fx`         | ` fx`         |
| `gemini`     | ` gemini`     |
| `gh`         | ` github`     |
| `git`        | ` git`        |
| `grok`       | ` grok`       |
| `hermes`     | ` hermes`     |
| `kdash`      | `󱃾 kdash`      |
| `kilo`       | ` kilo`       |
| `kimi`       | ` kimi`       |
| `lazydocker` | ` lazydocker` |
| `lazygit`    | ` lazygit`    |
| `mastracode` | ` mastracode` |
| `mix`        | ` elixir`     |
| `nvim`       | ` neovim`     |
| `opencode`   | ` opencode`   |
| `pi`         | ` pi`         |
| `posting`    | `󰒊 posting`    |
| `pspg`       | ` pspg`       |
| `qodercli`   | ` qodercli`   |
| `tuicr`      | ` tuicr`      |
| `tv`         | `󰟴 television` |
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

## Agent icons

Agent titles use custom glyphs from `Agent Mono Nerd Font`, which
Ghostty selects in `config/ghostty/config`. `task install` and `task sync`
install the four committed font faces from
`assets/fonts/AgentMonoNerdFont/`.

The stable private-use codepoints are:

| Agent       | Glyph | Codepoint |
| ----------- | ----- | --------- |
| Amp         |      | `U+E100`  |
| Claude Code |      | `U+E101`  |
| Cline       |      | `U+E102`  |
| Codex       |      | `U+E103`  |
| Copilot     |      | `U+E104`  |
| Cursor      |      | `U+E105`  |
| Gemini CLI  |      | `U+E106`  |
| Grok        |      | `U+E107`  |
| Hermes      |      | `U+E108`  |
| Kilo Code   |      | `U+E109`  |
| Kimi CLI    |      | `U+E10A`  |
| Mastra Code |      | `U+E10B`  |
| OpenCode    |      | `U+E10C`  |
| Pi          |      | `U+E10D`  |
| Qoder CLI   |      | `U+E10E`  |

Run `task fonts:update` to refresh the committed font from the latest Nerd
Fonts and Lobe Icons releases. The updater enforces a 30-day minimum interval;
see `assets/fonts/README.md` for details.
