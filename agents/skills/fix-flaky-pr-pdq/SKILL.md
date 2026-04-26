---
name: fix-flaky-pr-pdq
description: 'Fix a flaky test and complete the connected delivery workflow in PDQ repos: reproduce/fix, verify with repeat-until-failure, open a draft PR with low-risk labeling, wait for Elixir CI to pass, create a Linear Platform ticket labeled engineering task, update the PR title with the ticket key (for example [PLT-123]), and rerun ticket requirement checks.'
---

# Fix Flaky Pr Pdq

## Overview

Use this workflow when the user asks for end-to-end flaky-test remediation plus PR, CI, and ticket automation. Keep changes minimal, verify the flaky test with stress reruns, and finish with an auditable PR linked to a Linear ticket.

## Guardrails

- Work only on the requested flaky test and directly related code.
- Do not revert unrelated dirty workspace changes.
- Prefer deterministic test adjustments over production-code changes unless root cause is in production logic.
- Preserve the original intent of the test. If the only stable fix changes intent/coverage, stop and report that to the user instead of forcing a rewrite.
- Use conventional commits.
- Keep the PR in draft state until requested otherwise.

## Workflow

1. Identify the flaky test and nearby implementation.
   - Reproduce with a focused command first (single test or file).
   - Run dependency setup early: `mix deps.get` and `pnpm install`.

2. Apply the minimal fix.
   - Stabilize timing/race-sensitive tests with tighter control of batch sizes, delays, or assertions.
   - Prefer narrowing test setup to a single record when validating a specific race path.

3. Verify locally.
   - Run the specific test.
   - Run repeat-until-failure once for the target test (use the repo's expected iteration count, often 100).
   - Capture pass/fail outcome and seeds when available.

4. Commit and open draft PR.
   - Before commit/push, ensure dependencies are installed: `mix deps.get` and `pnpm install`.
   - Stage only relevant files.
   - Create a conventional commit message focused on why the test is now stable.
   - If a PR template exists under `.github/`, use it when composing the PR body.
   - Push branch and open a draft PR with clear summary and verification.
   - Prefer creating the PR with label at creation time (`--label "low risk"`) instead of a follow-up edit.

5. Wait for CI completion.
   - Poll PR checks with `gh` until Elixir tests complete.
   - Ignore non-blocking checks for this workflow such as Playwright suites and preview build/deploy (`Build and Push`, web preview).
   - Continue only when Elixir tests are successful.

6. Prepare Linear MCP access, then create Linear ticket.
   - Ensure MCP servers are synced first: `task ai:mcps:sync:default`.
   - Confirm Linear MCP is connected before ticket operations.
   - Team: Platform.
   - Add label: `engineering task`.
   - Save returned issue key (for example `PLT-123`).

7. Update the ticket with implementation status.
   - Add the draft PR URL.
   - Add commit SHA.
   - Include the core flaky failure signal (expected `{:error, _}`, got `:ok`) and test location.
   - Note the next action: rerun ticketing check after PR title is updated with issue key.

8. Update PR title and rerun ticket requirement check.
   - Update PR title to include the issue key suffix, for example: `fix: stabilize rbac downgrade flaky test [PLT-123]`.
   - Wait briefly for Linear automation to post the ticket comment on the PR.
   - Rerun the CI check named `Test / Ensure work is ticketed`.
   - Confirm the check passes.

## Command Patterns

- Dependency bootstrap:
  - `mix deps.get`
  - `pnpm install`
- MCP bootstrap:
  - `task ai:mcps:sync:default`
  - `opencode mcp list`
- Focused flaky verification:
  - `mix test path/to/test_file.exs:LINE`
  - `mix test path/to/test_file.exs:LINE --repeat-until-failure 100`
- PR lifecycle:
  - `gh pr create --draft --label "low risk" --title "..." --body-file .github/pull_request_template.md` (or another repo template path, when present)
  - `gh pr edit <pr-number> --add-label "low risk"`
  - `gh pr checks <pr-number> --watch`
  - `gh run rerun <run-id>` (for rerunning `Test / Ensure work is ticketed` once ticket metadata is present)
- Linear lifecycle (CLI naming may vary by environment):
  - Create issue via Linear MCP with Platform team + `engineering task` label.
  - Update created issue with PR URL, commit SHA, and failure context.
  - Capture the created key and inject it into the PR title.

## Completion Criteria

- Target flaky test is stable in repeat-until-failure run.
- Draft PR exists and has `low-risk` label.
- Elixir CI is green.
- Linear Platform issue with `engineering task` label exists.
- PR title contains the Linear key.
- Ticket requirement CI check has been rerun and passed.

## Example Failure Input

Use the exact user-provided failure to anchor reproduction:

```text
1) test run_rbac_downgrade/1 returns an error if none of the permissions are updated (Houston.RolesTest)
   lib/houston/roles_test.exs:487
   match (=) failed
   code:  assert {:error, _} = Task.await(task)
   left:  {:error, _}
   right: :ok
   stacktrace:
     lib/houston/roles_test.exs:514: (test)
```
