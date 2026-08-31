# Machine-local OpenCode MCPs

Use a machine-local overlay when an MCP integration should be available in
every OpenCode session on one machine, but must not be committed with these
dotfiles or enabled on other machines.

The shared OpenCode configuration lives at
`~/.config/opencode/opencode.jsonc`. It is symlinked from this repository.
The overlay below therefore also resolves into this repository, but is ignored
by Git.

## Setup

1. Create `~/.config/opencode/work-machine.jsonc`:

   ```jsonc
   {
     "$schema": "https://opencode.ai/config.json",
     "mcp": {
       "service-name": {
         "type": "remote",
         "url": "https://example.com/mcp",
         "enabled": true,
         "headers": {}
       }
     }
   }
   ```

   Add one entry per local-only MCP. Use `{env:VARIABLE_NAME}` in a header
   value when an MCP needs a secret; do not put credentials in the file.

2. Add this to the work machine's untracked `~/.zshrc.local`:

   ```zsh
   export OPENCODE_CONFIG="$HOME/.config/opencode/work-machine.jsonc"
   ```

   `OPENCODE_CONFIG` is loaded after the shared global configuration. Its
   contents are deep-merged, so the overlay adds or overrides only its own
   settings. Project-level OpenCode config loads later and can still override
   the machine defaults.

3. Open a new shell and restart OpenCode. OpenCode reads configuration only
   when it starts.

## Verify

Validate the overlay's JSON before starting OpenCode:

```sh
jq empty ~/.config/opencode/work-machine.jsonc
```

Confirm the overlay remains local to this machine:

```sh
git -C ~/dotfiles status --short
```

`config/opencode/work-machine.jsonc` is ignored by this repository. Do not
remove that ignore rule unless the overlay is intentionally becoming shared
configuration.
