# Pi configuration

Zsh sets `PI_CODING_AGENT_DIR=~/.config/pi/agent`. Mise links this
configuration directory into place.

## Synced and machine-local MCP servers

- **Synced:** edit `agent/mcp.shared.json` in this repository.
- **Machine-local:** use `pi mcp add`, or edit
  `~/.config/pi/agent/mcp.json`. This file is ignored by Git, as are MCP
  OAuth credentials and logs. Do not put secrets in the shared file.

Both files use Pi's normal format:

```json
{
  "mcpServers": {
    "docs": {
      "url": "https://example.com/mcp"
    }
  }
}
```

The `shared-mcp` extension registers synced servers when Pi loads.
Native user and trusted-project `mcp.json` entries override shared entries
with the same name; these are replacements, not deep merges. To disable a
shared server on one machine, copy its entry to the machine-local file and
set `enabled: false` (keep its `command` or `url`):

```json
{
  "mcpServers": {
    "docs": { "url": "https://example.com/mcp", "enabled": false }
  }
}
```

Use `/mcp` inside Pi to inspect both sets of servers. Run `/reload` after
editing either file. Changes to extension-registered servers in `/mcp`
last only for that session; edit the shared file for persistent changes.

Shell-level `pi mcp` commands do not load extensions, so `pi mcp list`,
`login`, `logout`, and `remove` only see native machine-local and trusted
project servers. Use the in-session commands for shared servers.
`pi mcp add --local` writes project configuration, not machine-local
configuration.

Run the extension tests with:

```sh
bun test ./config/pi/tests
```
