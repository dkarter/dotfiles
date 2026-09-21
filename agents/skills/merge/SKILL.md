---
name: merge
description: Finish a Herdr worktree by committing, rebasing, merging, and cleaning it up. Use only when the user explicitly invokes /merge or asks to merge the current branch. Never use for a commit-only request.
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep
---

<!-- Customize the commit style and rebase behavior to match your workflow. -->

**Arguments:** `$ARGUMENTS`

This skill performs the complete merge workflow. A request to commit, stage, or
save changes without rebasing and merging is outside this skill; handle it as a
normal Git operation in the current checkout.

Check the arguments for flags:

- `--keep`, `-k` keeps the environment after merging. This is skill behavior;
  do not pass it to `hwt remove`.

Strip all flags from arguments.

Before committing or rebasing, require `HERDR_ENV=1`, load `/hwt`, and capture
`hwt list --cwd "$PWD" --json`. Require it to identify the current workspace as
a linked worktree whose path differs from `source_checkout_path`. Stop without
changing the repository if either requirement is not met.

Commit, rebase, and merge the current branch.

This command finishes work on the current branch by:

1. Committing any staged changes
2. Rebasing onto the base branch
3. Merging and cleaning up with the backend that owns the worktree

## Step 1: Commit

If there are staged changes, inspect the repository instructions and recent
history to determine its commit convention. Repository-specific requirements
take precedence. Use Conventional Commits when the repository requires them;
otherwise use lowercase imperative mood without a prefix. Skip if nothing is
staged.

## Step 2: Rebase

Read the Herdr base-branch config:

```bash
git config --local --get "branch.$(git branch --show-current).herdr-base"
```

For a Herdr-owned worktree, require `herdr-base`. If it is missing, confirm the
intended base before merging rather than guessing.

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

Reuse the ownership response captured before Step 1.

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
  "hwt remove --workspace <worktree-workspace-id> --json && git branch -d <branch>; exit"
```

Parse both pane IDs from Herdr JSON responses. Do not target the focused pane or
construct IDs. Run removal from the helper so cleanup can finish after the
current workspace closes.
