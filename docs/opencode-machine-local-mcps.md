# Machine-local OpenCode MCPs

Use a machine-local overlay when an MCP integration should be available in
OpenCode projects under your home directory on one machine, but must not be
committed with these dotfiles or enabled on other machines.

The shared OpenCode configuration lives at
`~/.config/opencode/opencode.jsonc`. It is symlinked from this repository.
The machine-local overlay lives outside the repository at
`~/.opencode/opencode.jsonc`. OpenCode V2 discovers `.opencode/opencode.jsonc`
in ancestor directories, so projects under your home directory load it without
changing the shared global configuration or relying on `OPENCODE_CONFIG`.

## Setup

1. Create `~/.opencode/opencode.jsonc`:

   ```jsonc
   {
     "$schema": "https://opencode.ai/config.json",
     "mcp": {
       "servers": {
         "service-name": {
           "type": "remote",
           "url": "https://example.com/mcp"
         }
       }
     }
   }
   ```

   Add one entry per local-only MCP. Use `{env:VARIABLE_NAME}` in a header
   value when an MCP needs a secret; do not put credentials in the file.

2. If migrating from the old setup, move the existing file instead of copying
   it, and remove the now-unused `OPENCODE_CONFIG` export from `~/.zshrc.local`.
   V2 still accepts the old MCP entry syntax, but new entries should go under
   `mcp.servers`.

3. Restart the OpenCode service so it reloads the configuration:

   ```sh
   opencode service restart
   ```

Project-level OpenCode config can still override these machine defaults.
For projects outside your home directory, this ancestor-based overlay will not
load; configure those projects separately.

## Verify

Check that OpenCode discovers the machine-only servers:

```sh
opencode mcp list
```

Confirm the overlay is outside the repository:

```sh
ls -l ~/.opencode/opencode.jsonc
```

The old `config/opencode/work-machine.jsonc` path remains ignored by Git for
existing installations. Do not add the machine-local overlay to the shared
configuration.
