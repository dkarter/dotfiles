---
name: graphite
description: Manage stacked PR workflows with Graphite CLI in Graphite-enabled repos only; supports autonomous coordinator/workmux execution.
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep
---

# Graphite Stacked PRs

Use this skill for stacked PR workflows with `gt`.

## Scope Guard (required)

This skill applies only when the current repository is Graphite-enabled.

1. Verify Graphite is enabled:

```bash
test -f .git/.graphite_repo_config
```

2. If the file does not exist:
   - Stop using this skill.
   - Use normal git workflow (`git commit`, `git push`, `git rebase`, etc.).
   - Tell the user Graphite is not enabled in this repo.

Do not run `gt` commands in repos that fail this check.

## Coordinator / Workmux Compatibility

This skill must work in delegated background flows (for example `/coordinator`, `/worktree`, or `workmux send ...`).

- In delegated/autonomous runs, do not block on direct user approvals.
- Still plan the stack before coding, but proceed after presenting the plan in output.
- Choose reasonable defaults when details are missing and keep moving.
- Ask a question only when blocked by a true ambiguity or missing secret/credential.

## Stack Planning

Before implementation, define a small PR stack:

- One logical change per PR/branch
- Each PR should be independently testable
- Keep PRs focused and reviewable

Suggested plan format:

```text
PR Stack for <feature>
1. <pr-1-name>: <goal>
2. <pr-2-name>: <goal>
3. <pr-3-name>: <goal>
```

In interactive sessions, ask for confirmation only if the stack shape is materially ambiguous.

## Command Mapping

When Graphite is enabled, prefer `gt` over direct git branch/stack operations:

- New PR/branch: `gt create -am "<message>"`
- Update current PR: `gt modify -a`
- Submit stack: `gt submit --no-interactive`
- Sync/restack: `gt sync` (or `gt restack` when needed)
- Switch branch: `gt checkout <branch>`

Use standard git commands for read-only inspection as needed (`git status`, `git diff`, `git log`).

## Create vs Modify

- Use `gt create -am "..."` for a new atomic step in the stack.
- Use `gt modify -a` for follow-up edits to the current PR (review feedback, missed files, fixes).

## Daily Stack Workflow

```bash
gt sync
# implement next atomic step
gt create -am "feat: <message>"
# repeat for next steps
gt submit --no-interactive
```

## Conflict Handling

If `gt sync`/`gt restack` conflicts:

1. Inspect what changed in both sides.
2. Auto-resolve straightforward conflicts (formatting/import order/whitespace).
3. Resolve semantic conflicts carefully to preserve intent.
4. Continue with:

```bash
gt continue -a
```

If recovery is needed:

```bash
gt abort
```

## Navigation and Reorganization

- Inspect stack: `gt log`, `gt ls`
- Move through stack: `gt up`, `gt down`, `gt top`, `gt bottom`
- Reorganize: `gt move --onto <branch>`, `gt split`, `gt fold`, `gt squash`, `gt reorder`

## Output Expectations

- Keep users informed of stack shape and current branch position.
- Return Graphite stack/PR links when available.
- Be explicit when falling back to standard git because Graphite is not enabled.
