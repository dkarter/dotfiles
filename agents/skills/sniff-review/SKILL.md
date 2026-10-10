---
name: sniff-review
description: Launch an independent must-fix code review beside Hunk in Herdr, with Hunk on the left (80%) and an interactive reviewer on the right (20%). Use for `/sniff-review`, requests to sniff a PR, or AI-assisted local review with a follow-up agent pane. Check out PRs using hwt checkout; open local reviews in a new tab in the current workspace. Require explain-simply for every review comment.
---

# Sniff Review

Load the `herdr`, `hwt` (PR only), and `hunk-review` skills. Require `HERDR_ENV=1`.
Launch Hunk only through a Herdr pane, never as an interactive shell tool call.

## Launch

Run the bundled launcher from the requested repository:

```bash
python3 <skill-directory>/scripts/launch.py local --cwd /path/to/repo
python3 <skill-directory>/scripts/launch.py local --cwd /path/to/repo --revisions main...HEAD
python3 <skill-directory>/scripts/launch.py pr 'https://github.com/owner/repo/pull/123' --cwd /path/to/repo
```

Accept a PR number or `owner/repo#123` too. Pass `--remote NAME` for an ambiguous
PR remote. Default to the caller's agent harness; pass `--agent KIND` only when
the user requests another. Pass `--focus` only when asked to switch context.
Pass `--hwt-bin /path/to/hwt` only to select a different HWT executable.

- PR: run `hwt checkout --reuse`, preserving existing work without resetting it.
  Refuse a stale/dirty checkout. Review the fetched base-to-head comparison in
  the checked-out worktree. Use its new root pane, or create a dedicated review
  tab if the checkout was reused. Never take over an existing agent or editor.
  Do not use `hwt review`, its configured reviewer, or `--review-arg`.
- Local: create a new tab in the caller's workspace, preserving the current
  checkout. Default to staged, unstaged, and non-ignored untracked changes;
  `--revisions` instead selects the specified Git comparison without local edits.
- Split right at ratio `0.8`; start a separate interactive agent in the checkout
  and submit the review prompt. Open `hunk patch <captured-diff> --agent-notes`
  on the left. Leave both panes open for follow-up questions.

The launcher returns JSON containing workspace, tab, viewer pane, agent pane,
agent name, and a temporary review directory. Report those briefly and return;
do not wait for the review or duplicate it in the calling agent. The reviewer
adds its findings as local Hunk notes, never submits them to GitHub, and stays alive.
Notes belong to the live Hunk session; do not promise forge submission or durable
draft storage. Keep the findings JSON in the review directory for recovery.

## Reviewer handoff

The launcher supplies `references/reviewer.md`, `references/review-priorities.md`,
the `explain-simply` skill path, and the exact review context.
The side agent must not launch this skill recursively. Review in the checkout,
read project instructions and surrounding code, verify concrete failure paths,
and write findings through `scripts/add_findings.py` as instructed in the prompt.
Require the reviewer to load `explain-simply` before drafting and follow it for
every comment, including replies and follow-up notes. Apply review priorities
only where relevant; mark must-fix issues, not checklist gaps or preferences.

The helper anchors exact quoted code against the captured diff on either side,
supports explicitly selected hunks for broader issues, skips identical existing
notes by the same author, and refuses to post if the checkout or Hunk comparison
changed. Reject unmatched or ambiguous quotes instead of guessing a line.
Discover the exact Hunk session by its unique patch path, not UI focus or repo.
Apply all validated notes as one stdin batch without moving the user's focus.
Reject snapshots over 4 MiB or more than 250 untracked files instead of silently
truncating them.
It never guesses line numbers or fuzzy-matches filenames.

## Failures and follow-ups

Inspect the returned error and IDs. Leave partially created tabs/worktrees
available for repair; do not remove checkouts, kill existing agents, reset Git,
or silently treat startup failure as a clean review. A reviewer that requests
approval remains available in its pane; do not auto-approve.

For follow-ups, address the returned agent name with `herdr agent prompt`, or
let the user talk to it directly. Do not close its pane after completion.
If code changed, launch a fresh review instead of posting findings from the old
snapshot. Remove a PR worktree only on request, using `hwt remove`.

The review criteria and comment structure are adapted from sniffr's MIT-licensed
[review](https://github.com/tomasvarga/sniffr/blob/7ea59d31d163bd758ff428a82d63bad6fda6fdd1/prompts/review.md)
and [consensus](https://github.com/tomasvarga/sniffr/blob/7ea59d31d163bd758ff428a82d63bad6fda6fdd1/prompts/consensus.md)
prompts; see `references/sniffr-LICENSE`.
