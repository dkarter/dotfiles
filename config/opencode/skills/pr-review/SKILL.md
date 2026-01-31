---
name: pr-review
description: Review pull requests and leave line comments using the GitHub CLI (gh). Use for PR comparisons vs base branch, plan/spec alignment checks, summarizing findings, and writing review notes to files like tmp/reviews.md. Applies when asked to review a branch/PR or add PR comments.
---

# PR Review + Commenting

## Workflow

1. Gather context

- Identify PR number or current branch; use `gh pr view --json number,title,url,baseRefName,headRefName`.
- Get base comparison: `git diff --name-only <base>...HEAD` and `git diff <base>...HEAD`.
- Read plan/spec files mentioned by the user before judging alignment.
- Check repo guidance (`AGENTS.md`, `CLAUDE.md`, `rules/*`) for conventions.

1. Analyze changes

- Review all changed files, not just the latest commit.
- Verify correctness, best practices for the project's frameworks/tooling, tests, and plan/spec requirements.
- Verify clean architecture, good abstractions and adherence to project conventions
- Note gaps: missing features, mismatches with plan/ticket/requirments, unused deps, unhandled edge cases, missing tests, or naming/structure issues.

3. Draft review summary

- Write a concise summary (what changed, what aligns, what is missing).
- Call out required fixes separately from optional improvements.
- If asked, write summary to `tmp/reviews.md` with sections:
  - Summary
  - Plan Alignment
  - Changes Needed
  - Tests

4. Leave PR line comments (if requested). The user may want to review these before you post them, so don't publish those yet, keep them as part of a pending review

- Use `gh api` to create a pending review with line comments (omit `event` to keep it pending):
  - `gh api repos/{owner}/{repo}/pulls/{number}/reviews -f body='...' -F comments[][path]=<file> -F comments[][line]=<line> -F comments[][side]=RIGHT -f comments[][body]='...'`
- Prefer commenting on the exact line in the diff for each issue that needs a change.
- Keep comments specific, actionable, and reference the plan/spec/documentation if relevant.

## Commenting Tips

- Use integer line numbers from the diff (RIGHT side for new code).
- Avoid over-commenting; only flag changes needed or high-value improvements.
- For plan mismatches, cite the plan file and describe the missing requirement.

## Output Style

- Keep review summaries concise and scan-friendly.
- Use file path references with inline code.
- Separate required fixes from suggestions.
