# tv-zoxide.yazi

A Yazi plugin that integrates [television](https://github.com/alexpasmantier/television) with [zoxide](https://github.com/ajeetdsouza/zoxide) for smart directory jumping.

## Features

- Smart directory navigation using zoxide's frecency algorithm
- Visual directory selection via tv
- Preview directories before jumping

## Usage

Press `Z` in Yazi to:

1. Open tv with zoxide's most frequently/recently used directories
2. Preview directory contents
3. Jump to selected directory

## Dependencies

- [television](https://github.com/alexpasmantier/television)
- [zoxide](https://github.com/ajeetdsouza/zoxide)

## Configuration

Bind in `keymap.toml`:

```toml
{ on = "Z", run = "plugin tv-zoxide", desc = "Jump to a directory via tv+zoxide" }
```

The plugin uses the `zoxide` tv channel defined in `~/.config/television/cable/zoxide.toml`.
