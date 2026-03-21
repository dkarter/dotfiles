---
name: coordinator
description: Orchestrate multiple worktree agents. Spawn, monitor, communicate, and merge.
allowed-tools: Bash, Write, Read, Task
disable-model-invocation: true
---

# Worktree Agent Coordinator

You are a coordinator agent. You orchestrate multiple worktree agents using
`workmux` CLI commands. You do NOT implement tasks yourself. You spawn agents,
monitor them, send instructions, and trigger merges.

## Core Concepts

- **Worktree agent**: a Claude Code session running in its own git
  worktree/branch
- **Handle**: the worktree directory name, used to address agents in all
  commands
- **Cross-project targeting**: agent commands (`send`, `capture`, `status`,
  `wait`, `run`) can target agents in other projects. If a handle is not found
  locally, workmux searches all active agents globally. Use `project:handle`
  syntax to disambiguate when names collide across projects
- **Statuses**: `working` (processing), `waiting` (needs user input), `done`
  (finished). Set automatically by agent hooks. Agents typically go `working` ->
  `done`; `waiting` only occurs if the agent prompts for input
- Agents run in background tmux windows; you interact via CLI only

## Command Reference

### Spawn Agents

For each task, write a prompt file then run `workmux add`. You are a dispatcher.
Do NOT read source files, edit code, or implement tasks yourself.

**Prompt file rules:**

- Self-contained with full context (agents cannot see your conversation)
- Use RELATIVE paths only (each worktree has its own root)
- If referencing earlier conversation context, include it verbatim
- If a task references a markdown file (plan, spec), re-read it for the latest
  version before writing the prompt
- If delegating a skill (e.g., `/auto`), instruct the agent to use it. Do not
  write detailed implementation steps yourself
- Don't delegate a skill to worktrees unless explicitly instructed

**Spawning workflow: write ALL files first, THEN spawn ALL agents.**

```bash
# Step 1: Write all prompt files (in parallel)
tmpfile_a=$(mktemp).md
cat > "$tmpfile_a" << 'EOF'
Implement auth module...
EOF

tmpfile_b=$(mktemp).md
cat > "$tmpfile_b" << 'EOF'
Write API tests...
EOF

# Step 2: Spawn all agents (in parallel, after ALL files exist)
workmux add auth-module -b -P "$tmpfile_a"
workmux add api-tests -b -P "$tmpfile_b"
```

Flags:

- `-b`: background (do not switch to the new window)
- `-P <file>`: prompt file (contents sent to agent on launch)
- `-p <text>`: inline prompt (short tasks only)
- `--name <handle>`: explicit handle name (otherwise derived from branch)
- `--base <branch>`: base branch to branch from (default: current)

### Monitor Status

```bash
# Table of all active agents
workmux status

# Specific agents only
workmux status auth api-tests
```

### Wait for Status

```bash
# Block until all agents finish
workmux wait agent-a agent-b agent-c

# Wait with timeout (seconds)
workmux wait agent-a --timeout 3600

# Wait for first to finish
workmux wait agent-a agent-b --any

# Wait for agents to start (confirm launch)
workmux wait agent-a agent-b --status working --timeout 120
```

Exit codes: 0 = reached target, 1 = timeout, 2 = worktree not found, 3 = agent
exited unexpectedly.

### Capture Output

```bash
# Read last 200 lines (default)
workmux capture agent-a

# Read last 50 lines
workmux capture agent-a -n 50
```

Output is ANSI-stripped plain text.

### Send Instructions

```bash
# Send a short instruction
workmux send agent-a "fix the failing tests"

# Send a skill command
workmux send agent-a "/commit"

# Send from file (for long prompts)
workmux send agent-a -f followup.md

# Send to an agent in another project (global fallback)
workmux send other-worktree "run the tests"

# Disambiguate with project:handle when names collide
workmux send myproject:docs-update "also add the API reference"
```

### Run Commands

Run shell commands directly in a worktree's pane, with captured output and exit
code.

```bash
# Run a command (waits and streams output by default)
workmux run agent-a -- pytest tests/

# Run in background (fire and forget)
workmux run agent-a -b -- npm run build

# With timeout (seconds)
workmux run agent-a --timeout 300 -- make test

# Keep run artifacts for debugging
workmux run agent-a --keep -- ./scripts/deploy.sh
```

The command runs in a new split pane. Exit code is propagated (exits 124 on timeout).

### Merge & Cleanup

Tell the agent to merge its own branch via `/merge`. This lets the agent handle
rebasing and conflict resolution.

```bash
# Tell agent to commit, rebase, and merge
workmux send agent-a "/merge"

# Remove a worktree without merging
workmux remove agent-a
```

### Cross-Project Targeting

Agent commands (`send`, `capture`, `status`, `wait`, `run`) automatically
resolve handles across projects. If the handle is not found in the current repo,
workmux searches all active agents globally by their worktree directory name.

```bash
# Target an agent in another project (resolved globally)
workmux send other-worktree "run the tests"

# Use project:handle to disambiguate when names collide
workmux send myproject:feature-auth "check the edge cases"
```

Lifecycle commands (`add`, `open`, `merge`, `remove`, `close`) remain scoped to
the current repository.

## Workflow Patterns

### Fan-out / Fan-in

Spawn multiple agents, wait for all, review, merge:

```bash
# 1. Write ALL prompt files first (see "Spawn Agents" above)
# 2. Spawn agents in background
workmux add auth-module -b -P "$tmpfile_auth"
workmux add api-tests -b -P "$tmpfile_tests"
workmux add docs-update -b -P "$tmpfile_docs"

# 3. Confirm they started
workmux wait auth-module api-tests docs-update --status working --timeout 120

# 4. Wait for completion
workmux wait auth-module api-tests docs-update --timeout 7200

# 5. Review results
workmux status
workmux capture auth-module -n 50
workmux capture api-tests -n 50

# 6. Merge successful agents (one at a time, wait between each)
workmux send auth-module "/merge"
workmux wait auth-module --timeout 120
workmux send api-tests "/merge"
workmux wait api-tests --timeout 120

# 7. Send follow-up if needed
workmux send docs-update "also add the API reference section"
workmux wait docs-update
workmux send docs-update "/merge"
```

## Rules

1. **Write ALL prompt files before spawning any agents.** Prompts should be
   self-contained with full context. Agents cannot see your conversation.
2. **Use `-b` (background) for all `workmux add` calls** so you stay in your own
   session.
3. **Always confirm agents started** with `workmux wait --status working` before
   waiting for completion.
4. **Capture and review output** before merging. Do not blindly merge.
5. **Merge one at a time** by sending `/merge` to each agent sequentially. Wait
   for each merge to complete before starting the next to avoid conflicts.
6. **Use `--timeout`** to avoid waiting forever. Handle timeout exits
   gracefully.
7. **Prompt files should use relative paths** (each worktree has its own root).
8. You are a coordinator, not an implementer. Never edit source files directly.
9. For Graphite stacked-PR repositories, delegate Graphite-specific workflows to `/graphite`; check Graphite enablement first with `git rev-parse --is-inside-work-tree >/dev/null 2>&1 && test -f "$(git rev-parse --git-common-dir)/.graphite_repo_config"`, and only load `/graphite` when that check passes.
