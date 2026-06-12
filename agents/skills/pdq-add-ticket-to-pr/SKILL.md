---
name: pdq-add-ticket-to-pr
description: Add a Platform Linear ticket to a PDQ PR title, wait for linkback, and rerun the ticketing check.
disable-model-invocation: true
allowed-tools: Bash
---

# Skill: pdq-add-ticket-to-pr

## Overview

Use this workflow to add a Platform Linear ticket to an existing PDQ GitHub PR title, wait for the Linear linkback comment, and rerun the `Ensure work is ticketed` check.

## Scope Guardrail (required)

Run this skill only in PDQ repositories.

- Verify remote first: `git remote get-url origin`
- Continue only if remote matches `github.com/pdq/` (SSH or HTTPS)
- If not a PDQ repo, stop and report that this skill is out of scope

## Inputs

- PR number (or infer from current branch)
- Short ticket title
- Ticket body/context (PR URL, commit SHA, flaky/failure context)

## Linear IDs

- Platform team ID: `c1bc5af0-4726-4381-b85b-49e0fabd3b31`
- Dorian user ID: `e243e478-d3b3-4be0-84cc-cbb301e47ab6`
- `📋 Engineering Task` label ID: `9e12be59-5086-4064-afb3-b4dbf005effa`

## Efficient Workflow

1. Fetch minimal PR context once.
   - `gh pr view <pr> --json number,title,url,headRefName`
   - `git log -1 --format="%H"` for commit SHA

2. Create the Linear issue in Platform with the correct label.
   - Team: `Platform` (always use this)
   - Linear Issue Label: `📋 Engineering Task` (always required)
   - Capture the returned issue ID (for example `PLT-2976`)

   If the current branch has no PR and no upstream yet, fetch the created issue with the Linear MCP and rename the local branch before first push:
   - Use the issue's `gitBranchName` field exactly; this is Linear's Copy git branch value, for example `plt-3282-finish-oban-migration`
   - `git branch -m <linear-git-branch-name>`
   - Do not rename if a PR exists or the branch is already pushed

3. Update PR title by appending the issue id suffix.
   - Target format: `<existing title> [PLT-xxxx]`
   - the PR title must remain in conventional commits format and the issue id should always be appended at the end of the title. If the title becomes longer than 72 characters after adding the ticket you should rewrite it to be shorter without losing the intent/meaning and keeping conventional commits
   - Do not duplicate key if already present

4. Wait for Linear linkback comment on the PR.
   - Poll `gh api repos/pdq/<repo>/issues/<pr>/comments`
   - Success condition: comment from `linear[bot]` or comment body containing the exact ticket key

5. Rerun ticketing check in the fastest way.
   - Find failing check link from `gh pr checks <pr> --json name,state,link`
   - Locate `Ensure work is ticketed`
   - Extract run id from link: `.../actions/runs/<run_id>/job/...`
   - Rerun only failed jobs in that run: `gh run rerun <run_id> --failed`
   - Poll `gh pr checks` until `Ensure work is ticketed` is `SUCCESS` or `FAILURE`

## Command Patterns

- PR metadata:
  - `gh pr view <pr> --json number,title,url,headRefName,baseRefName`
- Check status:
  - `gh pr checks <pr> --json name,state,link`
- Rerun ticket check:
  - `gh run rerun <run_id> --failed`
- Wait for check:
  - poll `gh pr checks` for `Ensure work is ticketed`
- Wait for Linear comment:
  - poll `gh api repos/pdq/<repo>/issues/<pr>/comments`

## Completion Criteria

- Linear issue exists in Platform with `engineering task` label
- PR title ends with `[PLT-xxxx]`
- Linear bot linkback comment exists on the PR
- `Ensure work is ticketed` is rerun and finishes `SUCCESS`

## Notes

- Keep changes low-risk: this workflow only updates metadata (ticket + PR title + CI rerun)
- If Linear comment does not appear after reasonable retries, report partial completion and include current check state
