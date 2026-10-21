---
name: teleport-opencode
description: Teleport the current OpenCode conversation into another Herdr workspace, preserving its session and closing the source pane only after verification. Use when asked to teleport or relocate an OpenCode session to a new or existing Herdr workspace or directory. Requires HERDR_ENV=1.
---

# Teleport OpenCode

Keep this conversation; do not spawn an agent, fork, send a prompt, or use
`--continue`. Resume the exact session in a second terminal client.

1. Require `test "${HERDR_ENV:-}" = 1`; otherwise stop. Run
   `herdr pane current --current` and save `.result.pane.pane_id` as **source**
   and `.result.pane.agent_session.value` as **session**. Require agent
   `opencode`, session kind `id`, and a nonempty session ID; never guess it.
2. Resolve the absolute destination directory from the user's request. Reuse
   their requested workspace's available shell pane, or create one with
   `herdr workspace create --cwd <directory> --label <label> --no-focus`.
   Read `.result.root_pane.pane_id`; require destination != source. Never assume
   IDs. Do not create a worktree
   unless requested. Ask only if the destination is genuinely ambiguous.
3. Run `herdr agent start <unique-name> --kind opencode --pane <destination-pane>
   --timeout 5000 -- <directory> --session <session>`. Even if startup times out,
   run `herdr agent get <destination-pane>` and require agent `opencode` with
   `.result.agent.agent_session.value` equal to **session**. Do not wait for
   idle: the resumed conversation is already working, so interactive-readiness
   detection can time out despite successful startup. On missing identity,
   inspect the destination; never launch a duplicate client blindly.
4. Call OpenCode's `session_move` tool with `directory: <directory>` (omit
   `sessionID` to move this conversation). Require success and the same session
   ID and destination directory in its result.
5. Focus the destination with `herdr agent focus <destination-pane>`; only on
   success close the saved source: `herdr pane close <source>`. Never use
   `--current` for cleanup; caller context can change during the move.

Target three execution calls: (1) one shell call to capture/parse source and
session, create/reuse the destination, start, and verify; (2) `session_move`;
(3) focus && close. Print useful IDs and preserve startup errors; do not let a
startup timeout skip identity verification. Avoid sleep/poll loops. Load
`herdr`/`opencode` only for missing syntax or recovery.
On any verification failure, preserve the source pane and report the blocker.
