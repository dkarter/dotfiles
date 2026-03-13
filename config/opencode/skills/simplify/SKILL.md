---
name: simplify
description: Review changed code for reuse, quality, and efficiency, then fix issues found. Use after implementing a feature or bug fix.
argument-hint: '[focus area or concern]'
---

# Simplify

You are performing a post-change cleanup pass focused on code reuse, code quality, and efficiency.

If the user provided arguments, treat them as extra review focus:

$ARGUMENTS

## Phase 1: Identify Changes

Run `git diff` (or `git diff HEAD` if there are staged changes) to see what changed. If there are no git changes, review the most recently modified files that the user mentioned or that you edited earlier in this conversation.

## Phase 2: Launch Three Review Agents in Parallel

Use the Task tool to launch all three agents concurrently in a single message. Pass each agent the full diff so it has complete context.

### Agent 1: Code Reuse Review

Check for:

1. Existing utilities/helpers/components that could replace newly written code.
2. New functions that duplicate existing functionality.
3. Inline logic that should use existing utilities (for example string manipulation, path handling, parsing/formatting helpers).

### Agent 2: Code Quality Review

Check for:

1. Redundant state: duplicated state, cached values that can be derived.
2. Parameter sprawl: adding parameters instead of generalizing or restructuring.
3. Copy-paste with variation: near-duplicate code that should become a shared abstraction.
4. Leaky abstractions: exposing internals or breaking abstraction boundaries.
5. Stringly-typed code: raw strings where constants/enums/string unions/typed variants already exist.
6. Unnecessary JSX nesting: wrappers that add no layout value when child/component props already handle layout.

### Agent 3: Efficiency Review

Check for:

1. Unnecessary work: redundant computation, repeated reads, N+1 patterns.
2. Missed concurrency: independent operations run sequentially.
3. Hot-path bloat: blocking work in startup or per-request paths.
4. Recurring no-op updates: unconditional state/store updates in loops, intervals, or handlers; add change detection guards.
5. Unnecessary existence checks: pre-checking file/resource existence before use (TOCTOU); operate directly and handle errors.
6. Memory issues: unbounded structures, missing cleanup, listener/timer leaks.
7. Overly broad operations: reading full files/datasets when only a subset is needed.

## Phase 3: Fix Issues

Wait for all three agents to complete. Aggregate findings and fix each valid issue directly.

If a finding is a false positive or not worth addressing, note it and move on. Do not argue with the finding.

If you made code changes, run the project's relevant tests after applying fixes. Prefer targeted tests first, then broader test suites when appropriate.

When done, briefly summarize what was fixed, or confirm the code was already clean.
