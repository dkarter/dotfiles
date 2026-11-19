# Native Herdr shortcuts

Mise installs the mods and the `terminals-focus` layout under
`~/.config/herdr-app/`. It merges `keys.json` into the native app's keymap,
preserving keys not listed here. Select `terminals-focus` in the native app
for the cyan active-pane border.

Nothing is installed into the TUI's config or plugins. Neovim prefers the
TUI navigator when both the TUI and native terminal environments are present.

- Copy mode: move with `hjkl`, arrows, `w`/`b`/`e`, `W`/`B`/`E`, `g`/`G`,
  or `0`/`$`. Scroll half a page with `Ctrl+U`/`Ctrl+D` and a full page with
  Page Up/Down or `Ctrl+B`/`Ctrl+F`.
  Select with `v`, Space, or `V` (line). Copy with `y` or Enter, or leave
  without copying with Esc or `q`.
- Navigation: when a Vim editor is in the foreground, the shortcut goes to
  the editor. This repo's Neovim config moves to the next native pane when
  there is no split in that direction. The app CLI must be reachable from
  Neovim for that handoff.
- Resize: moves the nearest weighted divider in the requested direction.
  This resizes native splits, even when Neovim is focused.
