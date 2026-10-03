---
name: gh-stack
description: Manage stacked GitHub pull requests with the official `github/gh-stack` extension. Use for creating, viewing, rebasing, syncing, submitting, or merging PR stacks with `gh stack`. Don't use for non-stacked pull requests.
---

# gh stack

- Check `gh stack --help` and the relevant subcommand help before changing a stack.
- Use `gh stack init <branch>` to start, `gh stack add <branch>` to add a layer, and `gh stack view` to inspect it.
- Use `gh stack rebase` to update dependent branches and `gh stack sync` to reconcile with GitHub.
- When asked to open PRs, use the `open-pr` skill; `gh stack submit --auto` creates drafts by default. Never use `--open` unless explicitly asked to mark PRs ready.
- Do not run `gh stack merge` without an explicit merge request from the user.
