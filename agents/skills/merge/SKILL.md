---
name: merge
description: Commit, rebase, and merge the current branch.
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep
---

<!-- Customize the commit style and rebase behavior to match your workflow. -->

**Arguments:** `$ARGUMENTS`

Check the arguments for flags:

- `--keep`, `-k` keeps the environment after merging. In Herdr this is skill
  behavior; do not pass it to `herdr worktree remove`.
- `--no-verify`, `-n` is supported only by the workmux backend. Do not invent a
  Herdr equivalent or pass it to a Herdr command.

Strip all flags from arguments.

If `HERDR_ENV=1` and `--no-verify` or `-n` was supplied, stop before committing,
rebasing, or merging. Explain that this workmux flag has no verified Herdr
equivalent.

Commit, rebase, and merge the current branch.

This command finishes work on the current branch by:

1. Committing any staged changes
2. Rebasing onto the base branch
3. Merging and cleaning up with the backend that owns the worktree

## Step 1: Commit

If there are staged changes, commit them. Use lowercase, imperative mood, no conventional commit prefixes. Skip if nothing is staged.

## Step 2: Rebase

Choose the base-branch config for the active backend:

```bash
# Herdr
git config --local --get "branch.$(git branch --show-current).herdr-base"

# workmux outside Herdr
git config --local --get "branch.$(git branch --show-current).workmux-base"
```

For a Herdr-owned worktree, require `herdr-base`. If it is missing, confirm the
intended base before merging rather than guessing.

For other worktrees, default to "main" when no base branch is configured.

Rebase onto the local base branch (do NOT fetch from origin first):

```
git rebase <base-branch>
```

IMPORTANT: Do NOT run `git fetch`. Do NOT rebase onto `origin/<branch>`. Only rebase onto the local branch name (e.g., `git rebase main`, not `git rebase origin/main`).

If conflicts occur:

- BEFORE resolving any conflict, understand what changes were made to each
  conflicting file in the base branch
- For each conflicting file, run `git log -p -n 3 <base-branch> -- <file>` to
  see recent changes to that file in the base branch
- The goal is to preserve BOTH the changes from the base branch AND our branch's
  changes
- After resolving each conflict, stage the file and continue with
  `git rebase --continue`
- If a conflict is too complex or unclear, ask for guidance before proceeding

## Step 3: Merge

Choose the owner before cleanup:

1. If `HERDR_ENV=1`, never run workmux. Capture `herdr worktree list --cwd
   "$PWD" --json` once and require it to identify the current workspace as a
   linked worktree whose path differs from `source_checkout_path`. Stop if it
   does not.
2. Outside Herdr, use the workmux path only when `$TMUX` is set.

### Herdr path

Reuse the captured response to read the source checkout path, source workspace
ID, current workspace ID, worktree path, and branch. Before merging, verify that
the source checkout is clean and currently on the base branch. Then fast-forward
it to the rebased branch:

```bash
git -C <source-checkout> merge --ff-only <branch>
```

With `--keep`, stop here. Otherwise create a short-lived, unfocused helper pane
in the source workspace and have it remove the Herdr worktree, delete the merged
branch, and exit:

```bash
herdr pane split <source-pane-id> --direction down --cwd <source-checkout> --no-focus
herdr pane run <helper-pane-id> \
  "herdr worktree remove --workspace <worktree-workspace-id> --json && git branch -d <branch>; exit"
```

Parse both pane IDs from Herdr JSON responses. Do not target the focused pane or
construct IDs. The helper is necessary because removing the current workspace
terminates the calling pane.

### workmux path

Never use this path when `HERDR_ENV=1`.

Run: `workmux merge --rebase --notification [--keep] [--no-verify]`

Include `--keep` only if the `--keep` flag was passed in arguments.
Include `--no-verify` only if the `--no-verify` flag was passed in arguments.

This merges the branch into the base branch and cleans up the workmux-owned
worktree and tmux window unless `--keep` is used.
