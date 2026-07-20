---
name: worktree
description: Launch one or more tasks in new git worktrees using Herdr when inside Herdr, otherwise workmux.
disable-model-invocation: true
allowed-tools: Bash, Write
---

Launch one or more tasks in new git worktrees using the active multiplexer.

Tasks: $ARGUMENTS

## You are a dispatcher, not an implementer

**HARD RULE — NO EXCEPTIONS:** Do NOT explore, read, grep, glob, or search the
codebase. Do NOT use the Task/Explore agent. Do NOT investigate the problem. You
are a thin dispatcher. Your only job is to write prompt files and dispatch
worktree agents. The worktree agent will do all exploration and implementation.

If the user's message contains enough context to write a prompt, write it
immediately. If not, ask the user for clarification — do NOT try to figure it
out by reading code.

If tasks reference earlier conversation (e.g., "do option 2"), include all
relevant context in each prompt you write.

If tasks reference a markdown file (e.g., a plan or spec), re-read the file to
ensure you have the latest version before writing prompts.

For each task:

1. Generate a short, descriptive worktree name (2-4 words, kebab-case)
2. Write a detailed implementation prompt to a temp file
3. Dispatch with the backend selected below.

The prompt file should:

- Include the full task description
- Use RELATIVE paths only (never absolute paths, since each worktree has its own
  root directory)
- Be specific about what the agent should accomplish

## Skill delegation

If the user passes a skill reference (e.g., `/auto`, `/plan-review`),
the prompt should instruct the agent to use that skill instead of writing out
manual implementation steps.

**Skills can have flags.** If the user passes `/auto --gemini`, pass the
flag through to the skill invocation in the prompt.

Example prompt:

```
[Task description here]

Use the skill: /skill-name [flags if any] [task description]
```

Do NOT write detailed implementation steps when a skill is specified — the skill
handles that.

## Flags

**`--merge`**: When passed, add instruction to use `/merge` skill at the end to
commit, rebase, and merge the branch.

```
...
Then use the /merge skill to commit, rebase, and merge the branch.
```

## Workflow

Write ALL temp files first, then dispatch all agents.

### Backend selection

1. If `HERDR_ENV=1`, use Herdr, even if `$TMUX` is also set.
2. Otherwise use `workmux add` as before.

Never run workmux inside Herdr. If the user explicitly requests it there,
explain that workmux is tmux-specific and ask whether to use native Herdr
worktrees instead. Never use Herdr to take over an existing workmux-owned
worktree.

### Herdr

Load the `/herdr` skill and inspect the installed CLI before dispatching. For
each task:

1. Record the current branch as the base branch.
2. Run `herdr worktree create --cwd "$PWD" --branch <worktree-name> --base
   <base-branch> --no-focus --json`.
3. Record the base for `/merge` with `git config
   branch.<worktree-name>.herdr-base <base-branch>`.
4. Read the workspace ID from the JSON response.
5. Follow `/herdr` to start the requested agent, submit the prompt file, and
   confirm it reached `working`. Default to the current pane's agent.
6. Keep a mapping of worktree name to the returned workspace and pane IDs.

Create all worktrees before waiting for agents so independent tasks launch in
parallel. Use `--no-focus` throughout.

### workmux

Use this section only when `HERDR_ENV` is not `1` and `$TMUX` is set.

**IMPORTANT:** Run `workmux add` from the CURRENT directory. Do NOT `cd` to the
main repo or any other directory. The new worktree branches from whatever branch
is checked out in the current directory.

Step 1 - Write all prompt files (in parallel):

```bash
tmpfile=$(mktemp).md
cat > "$tmpfile" << 'EOF'
Implement feature X...
EOF
echo "$tmpfile"  # Note the path for step 2
```

Step 2 - After all files are written, run workmux commands in parallel:

```bash
workmux add feature-x -b -P /tmp/tmp.abc123.md
workmux add feature-y -b -P /tmp/tmp.def456.md
```

After creating the worktrees, inform the user which branches were created.

**Remember:** Your task is COMPLETE once worktrees are created. Do NOT implement
anything yourself.
