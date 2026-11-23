# Capture TUI screenshots with `tui-shot`

[`tui-shot`](https://github.com/dkarter/tui-shot) reads a Herdr pane without
focusing it. Install the Rust binary with Mise; it renders PNG directly
without Python or a separate renderer.

```sh
mise use -g packslip:github.com/dkarter/tui-shot
```

The dotfiles Mise config exempts `tui-shot` from its release-age delay. On
other setups, pin the exact version to install a release before the delay ends.

```sh
# Capture another pane; use `herdr pane list` to find its ID.
tui-shot --pane "$pane" --title "My app · Overview" -o overview.png

# Omit --pane to capture the calling pane ($HERDR_PANE_ID).
tui-shot -o overview.svg

# Save the viewport once, then render it in multiple formats.
tui-shot --pane "$pane" -o overview.ansi
tui-shot --input overview.ansi --theme light -o overview.html
tui-shot --input overview.ansi -o overview.txt
```

PNG is rendered at 2×. The PNG and SVG fit the returned content rather than
padding it to the pane size. Herdr can omit blank viewport edges and does not
export the cursor in this snapshot. Font fallback and complex Unicode can look
different from the original terminal. `--input` expects a screen snapshot, not
a recording of cursor movements.

## Publish selectable text

HTML keeps the terminal text selectable and preserves its existing Unicode,
including box drawing. Publish the standalone file or add `--fragment` to
embed the card in a page that allows inline styles. To switch palettes, change
`data-theme="dark"` to `data-theme="light"` on the `<figure>`. To customize
further, add CSS such as:

```css
.tui-shot {
  --tui-bg: #10141c;
  --tui-fg: #eaf2ff;
  --tui-bar: #1e2736;
  --tui-c6: #5eead4;       /* ANSI cyan; c0–c15 are palette entries */
  --tui-rgb-fa9646: #ffcc66; /* optional override for one exact RGB color */
}
```

Review captures before publishing. They contain the pane's visible contents,
which may include private data. `.ansi` is the raw export, not a sanitized
publishing format.

## Script a tutorial

Open the app in a dedicated Herdr pane, keep its size consistent between runs,
and pass its ID to your script. For each step, send keys, wait for text specific
to that screen, then capture it. For example, if your app opens settings with
`s` and shows a unique heading:

```sh
set -e
pane="${1:?pass the demo pane ID}"
herdr pane send-keys "$pane" s
herdr pane wait-output "$pane" --source visible --match 'Settings — General' \
  --timeout 5000 >/dev/null
tui-shot --pane "$pane" --title "02 · Settings" -o 02-settings.png
```

Agents can use the same commands and open the resulting PNG to check layout.
