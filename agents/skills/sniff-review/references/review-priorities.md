# Review priorities

Use these as lenses, not a mandatory checklist. Choose the ones that fit the
language, system, change, and ticket. Mark only verified must-fix issues. For
each, explain a concrete failure, unsafe deployment, security exposure, or
violated requirement. Do not turn preferences into blockers or fill a quota.

## 1. Solve the right problem

- Compare the change with the ticket and stated intent. Look for missing required
  behavior, scope drift, bugs, wrong assumptions, and an approach that cannot
  meet the requirement.
- Check for a simpler existing solution or helper. Duplication alone is not a
  blocker; explain any conflicting behavior or maintenance risk that creates
  a concrete defect.
- Consider whether the PR is reviewable or needs splitting. Size alone is not a
  must-fix finding; unsafe ordering of independent deployment steps can be.

## 2. Tests

- Check that tests assert behavior, not just implementation details. Inspect
  edge cases, failure paths, and whether regression tests would catch the bug
  the PR claims to fix.
- Do not flag missing tests alone. Flag demonstrated broken behavior, false
  assertions that hide a real defect, or failure to meet a required validation
  contract. Run safe, focused checks when they help verify a concern.

## 3. Deploy safety and compatibility

- Check mixed-version deploys: migration/code ordering, dropped or renamed
  columns, changed enum values, old clients, and old workers processing queued jobs.
- Check API, event, and serialized-payload contracts. Trace their consumers.
- Examine rollback paths and feature flags where failure has serious impact.
- Look for locks on hot tables, large backfills inside schema-change transactions,
  and missing concurrent index creation where the database supports it. Ground
  the risk in the actual database, table usage, and deployment process.

## 4. Failures and error handling

- Trace external-call, queue, and database failures. Check appropriate timeouts,
  retries, and idempotency: repeating a request must not repeat its effects.
- Look for swallowed errors and broad rescue/catch blocks that hide failures.
- Check races, double submissions, and background jobs that cause duplicate
  effects when retried. Describe the failing sequence, not just a code smell.

## 5. Security and dependencies

- Check tenant isolation and authorization within a tenant, including regular
  users reaching admin-only actions and missing role/permission checks.
- Inspect input validation, SQL/command injection, path traversal, and assignment
  of fields users should not control.
- Look for exposed secrets or personal/sensitive data in code, config, logs,
  error trackers, and analytics. Do not open credential values to investigate;
  report the exposure without copying a secret into a review comment.
- For added dependencies, check necessity, reputation, maintenance, license
  compatibility, and unexpected transitive changes in the lockfile. Consider an
  existing helper or small vendored implementation where it makes sense. Do not
  treat low downloads, personal preference, or an unfamiliar package as proof of
  risk. Verify a concrete supply-chain or licensing problem before marking it.

## 6. Observability

- Ask whether a production failure can be detected and diagnosed with the
  available logs, metrics, traces, alerts, and error context.
- Flag a concrete critical failure that becomes silent or impossible to diagnose,
  not a generic demand for more telemetry. Avoid leaking sensitive data in the fix.

## 7. Performance

- Check expensive migrations/queries, suspicious query timeouts, N+1 access,
  missing indexes for new access patterns, and unbounded queries without limits
  or pagination.
- Check work in the request path that needs a background job, and whole-table or
  whole-file loads that can exhaust memory.
- Use realistic input sizes, query plans, known load, or established limits.
  Do not block on speculative micro-optimizations.

## 8. Maintainability

- Check readability, coherence, intent-revealing names, comments that explain
  why, reused helpers, dead code, leftover debug statements, and unfinished TODOs.
- Check docs, READMEs, and runbooks needed for correct use, deploys, or recovery.
- Mark these only when they cause a concrete wrong behavior, unsafe operation,
  or unmet requirement. Keep subjective cleanup and wording preferences out of
  the must-fix comments.
