---
name: dev-process
description: Start a development server or other long-running process. Use when the user asks to start, run, launch, or restart a dev server, watcher, worker, or persistent local command. When running inside Herdr, launch it in a separate background tab.
---

# Dev Process

Determine the command from the repository's documented workflow or the user's
request. Ask only if it is ambiguous.

If `HERDR_ENV=1`:

1. Run `herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd "$PWD" --label "<short process name>" --no-focus`.
2. Read the root pane ID from `.result.root_pane.pane_id` in the JSON response.
3. Run `herdr pane run <pane-id> '<command>'`.
4. Report the tab and command. Do not wait for the process or change focus.

Otherwise, start the command with the available terminal execution mechanism.
Do not start a duplicate when the requested process is already running.
