---
name: coordinator
description: Orchestrate multiple worktree agents through Herdr. Spawn, monitor, communicate, and merge. Do not invoke automatically.
allowed-tools: Bash, Write, Read, Task
disable-model-invocation: true
---

# Worktree Agent Coordinator

You are a coordinator agent. You do NOT implement tasks yourself. You spawn
agents, monitor them, send instructions, and trigger merges.

## Herdr Backend

Load `/hwt` for worktree lifecycle and `/herdr` for pane and agent control. Keep
a mapping from each task name to its returned workspace ID and pane ID.
If `HERDR_ENV` is not `1`, stop and explain that coordination requires Herdr.

### Spawn

1. Write all prompt files before creating any worktree.
2. Record the current branch as the base branch.
3. Follow `/hwt` to create each worktree from that explicit base branch.
4. Retain the returned workspace and pane IDs, then follow `/herdr` to start the
   requested agent, submit the prompt, and confirm it reached `working`. Default
   to the current pane's agent.

Create all independent worktrees before waiting so startup remains parallel.

### Monitor and communicate

Follow `/herdr` for status waits, output reads, and follow-up input. Treat either
`idle` or `done` as completed after inspecting the pane. If an agent is
`blocked`, read its output and provide the needed input. Use `--no-focus` for
background work.

### Merge and cleanup

Review each agent's output before asking it to use `/merge`. Merge sequentially.
The `/merge` skill must use the same Herdr-owned workspace lifecycle. Follow
`/hwt` to remove an abandoned Herdr worktree.

## Rules

1. **Write ALL prompt files before spawning any agents.** Prompts should be
   self-contained with full context. Agents cannot see your conversation.
2. **Keep background pane and agent operations unfocused.**
3. **Always confirm agents reached `working`** before waiting for completion.
4. **Read and review agent output** before merging. Do not blindly merge.
5. **Merge one at a time** by sending `/merge` to each agent sequentially. Wait
   for each merge to complete before starting the next to avoid conflicts.
6. **Use bounded waits** to avoid waiting forever. Handle timeout exits
   gracefully.
7. **Prompt files should use relative paths** (each worktree has its own root).
8. You are a coordinator, not an implementer. Never edit source files directly.
9. For Graphite stacked-PR repositories, delegate Graphite-specific workflows to `/graphite`; check Graphite enablement first with `git rev-parse --is-inside-work-tree >/dev/null 2>&1 && test -f "$(git rev-parse --git-common-dir)/.graphite_repo_config"`, and only load `/graphite` when that check passes.
