---
name: open-pr
description: Always use this skill for PR creation. Use whenever the user asks to open, create, draft, prepare, or submit a pull request, unless they explicitly ask for raw CLI/API commands instead.
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep
---

<!-- This is a starting point. Customize the template and guidelines to match your team's PR conventions. -->

## Gather context

1. Get the base branch (usually `main` or `master`)
2. Get the diff: `git diff <base>...HEAD`
3. Get commit messages: `git log <base>...HEAD --format="%s"`
4. Read changed files to understand the broader context

## Commit uncommitted changes

1. Run `git status` to check for uncommitted changes
2. If changes exist, commit them before proceeding

## Write PR description

First, check whether the repository has a PR template. Look in these common locations:

- `.github/pull_request_template.md`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/PULL_REQUEST_TEMPLATE/*.md`

If a template exists, use it as the PR body format and fill it in using the conversation and git context.

If no template exists, use this fallback template:

```markdown
# Motivation

[1-2 sentences: what this PR does and why]

# Summary of Changes

- [Key change 1]
- [Key change 2]
- [Key change 3]

# Testing

[How you verified it works]

# Dependencies/Special Considerations

[only if there are any list them - e.g. other prs that need to be merged, manual
steps that need to be taken - otherwise say "none"]
```

Guidelines:

- Lead with a concise summary of what the PR does
- Explain the "why" before the "how"
- Use the conversation context to inform the description
- Include before/after comparisons for UI or performance changes
- Be concise, direct and to the point
- Use the "humanizer" skill to improve writing
- IMPORTANT: always keep the pr in DRAFT mode - only a human should be allowed take a PR out of draft mode

## Create the PR

1. Write a short PR title (max 72 characters)

2. Ensure the branch is pushed:
   ```bash
   git push -u origin HEAD
   ```

3. Open PR creation in browser (do NOT create directly):
   ```bash
   gh pr create --draft --title "<title>" --body "<body>"
   ```
