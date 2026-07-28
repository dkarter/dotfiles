# Troubleshooting

## OpenCode fails with a Node syntax error

If `mise exec -- opencode completion` tries to parse `opencode.exe` with Node,
upgrade to mise 2026.7.15 or newer and regenerate the stale aube shim:

```sh
mise install --force npm:opencode-ai
```

OpenCode's completion command is singular: `opencode completion`.
