# tv.yazi

A Yazi plugin that integrates [television](https://github.com/alexpasmantier/television) for fuzzy finding and navigation.

## Features

- Supports any tv channel as an argument
- Fuzzy file/directory finding using tv channels
- Works with Yazi's selection system
- Respects current working directory
- Handles both single and multiple file selections
- Smart behavior based on channel type (directory-only vs file channels)

## Usage

### Basic Usage

- **No arguments**: Opens tv's `files` channel (default)
- **With channel argument**: Opens the specified tv channel

### Examples

```toml
# In keymap.toml
{ on = "z", run = "plugin tv", desc = "Jump to a file/directory via tv (files)" }
{ on = "Z", run = "plugin tv -- zoxide", desc = "Jump to a directory via tv+zoxide" }
{ on = "<C-d>", run = "plugin tv -- dirs", desc = "Jump to a directory via tv (dirs)" }
{ on = "<C-g>", run = "plugin tv -- git-repos", desc = "Jump to a git repo via tv" }
```

### Channel Behavior

**Directory-only channels** (automatically detected):

- `zoxide` - Jump to frecent directories
- `dirs` - Browse all directories
- `dev-dirs` - Browse development directories

These channels will always `cd` to the selected directory.

**File/mixed channels**:

- `files` (default) - Browse files
- `git-repos` - Browse git repositories
- Any other tv channel

These channels will reveal files or `cd` to directories based on selection.

### With Selection

When files are selected in Yazi, the plugin creates a temporary channel with your selected files for quick navigation, ignoring the channel argument.

## Dependencies

- [television](https://github.com/alexpasmantier/television)
- [bat](https://github.com/sharkdp/bat) (for file previews)
- [fd](https://github.com/sharkdp/fd) (used by tv's files channel)
- Additional dependencies based on channels used (e.g., `zoxide` for the zoxide channel)

## Configuration

Bind in `keymap.toml` with optional channel arguments:

```toml
# Default files channel
{ on = "z", run = "plugin tv", desc = "Jump to a file/directory via tv" }

# Specific channels
{ on = "Z", run = "plugin tv -- zoxide", desc = "Jump to a directory via tv+zoxide" }
{ on = "<leader>d", run = "plugin tv -- dirs", desc = "Browse directories" }
```
