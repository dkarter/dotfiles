# tv.yazi

A Yazi plugin that integrates [television](https://github.com/alexpasmantier/television) for fuzzy file finding and navigation.

## Features

- Fuzzy file/directory finding using tv's `files` channel
- Works with Yazi's selection system
- Respects current working directory
- Handles both single and multiple file selections

## Usage

Press `z` in Yazi to activate:

- **Without selection**: Opens tv's file browser for fuzzy finding
- **With selection**: Opens tv with your selected files for quick navigation

## Dependencies

- [television](https://github.com/alexpasmantier/television)
- [bat](https://github.com/sharkdp/bat) (for file previews)
- [fd](https://github.com/sharkdp/fd) (used by tv's files channel)

## Configuration

Bind in `keymap.toml`:

```toml
{ on = "z", run = "plugin tv", desc = "Jump to a file/directory via tv" }
```
