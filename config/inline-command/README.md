# Inline commands

Shared prompt preprocessing for OpenCode, Claude Code, Codex and Pi. It expands
`!` followed by a backtick-delimited shell command on submission, preserving the
command, exit status, stdout and stderr. Execution needs no model call.

Try typing this as ordinary prompt text:

```text
What time is it? !`date`
```

Commands run through `$SHELL -c` (or `/bin/sh`) in the session working directory.
There is no allowlist or per-command approval. Pipes, substitutions, redirects
and side effects are supported. Only use this syntax for commands you intend
to execute; it bypasses agent tool permissions.

Escaped syntax, ordinary Markdown code spans, fenced code blocks and indented
code are left literal. Each prompt executes at most four commands, each with a
five-second timeout and a combined 16 KiB output limit. Output uses the shared credential
redactor and is not recursively expanded.

## Adapters and installation

- OpenCode: `config/opencode/plugins/inline-command/`, explicitly registered in
  `opencode.jsonc`. The prompt hook stores the expanded prompt.
- Pi: `config/pi/agent/extensions/inline-command.ts`. The input hook transforms
  typed prompts and preserves images. Extension-injected messages are skipped.
- Claude: `claude/` is a native mod that rewrites the displayed prompt through
  `prompt.submit`, using `prepare.ts` to call the shared core. Requires Claude
  Code 2.1.287 or later. The command hook remains a fallback if mods cannot load.
- Codex: `hook.ts` reads `UserPromptSubmit` JSON from stdin, displays captured
  results as a hook message and delivers them as `additionalContext`, telling
  the agent not to rerun them. Codex cannot rewrite the displayed user prompt.

Apply config links with `mise bootstrap dotfiles apply --yes`, then run
`sh config/inline-command/install.sh`. The installer merges the hook into
`~/.claude/settings.json` and `~/.codex/hooks.json`, preserving other hooks.
It also registers the Claude mod and removes obsolete workmux status hooks.
`task install` and `task sync` also install these hooks. Start fresh Claude/Pi
sessions after installation. In Codex, review and trust the new hook in `/hooks`.

Herdr reads require real context in the process executing the command. A shared
server started outside Herdr may not have that context. The pane picker wraps
its command in this syntax; each receiving harness needs its adapter installed.

OpenCode prompt admission can invoke hooks more than once for concurrent
submissions. Commands are not guaranteed exactly-once; be mindful of side effects.

Run tests with `bun test config/inline-command config/opencode/inline-command`.

Verify live activation with `opencode plugin list`. Local unit tests alone do not
verify OpenCode's plugin loader. A live admission test with `resume: false` can
verify expansion without making a model request.
