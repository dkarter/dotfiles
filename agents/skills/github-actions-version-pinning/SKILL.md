---
name: github-actions-version-pinning
description: Verify and pin GitHub Actions versions in workflow files. Use when creating, editing, or reviewing `.github/workflows/*` files, changing `uses:` references, adding external actions, responding to CI/security review feedback about action versions, or checking whether actions are pinned to the latest appropriate version.
---

# GitHub Actions Version Pinning

## Overview

Ensure workflow actions use current, intentional pins. Prefer exact patch tags or immutable SHAs for third-party actions when practical; use latest major tags only when the repository convention or user explicitly asks for major-version pins. Treat non-GitHub actions as supply-chain risk unless the user or repository policy has already approved them.

## Workflow

1. Identify every `uses:` reference in changed workflow files.
2. Classify each reference:
   - Official GitHub action: `actions/*`, `github/*`.
   - Third-party action: everything else.
   - Local action: `./...`; do not version-pin local actions.
   - Existing SHA pin: preserve it unless the user explicitly asks to update or replace it.
3. Check the official upstream source for the latest release before changing versions.
   - Prefer `gh release view --repo OWNER/REPO --json tagName,isLatest` when authenticated and available.
   - Otherwise fetch `https://github.com/OWNER/REPO/releases/latest` or inspect upstream tags.
4. Apply pinning policy:
   - Respect repository policy first. Some repositories consider official GitHub actions safe with tag pins; others require SHA pins for every external action.
   - Default security preference: pin external actions to the latest exact patch tag, for example `actions/checkout@v6.0.2` or `jdx/mise-action@v4.0.1`.
   - If the user or repo policy asks for major-version pins, pin to the latest major tag, for example `actions/checkout@v6`.
   - If GitHub's API shows a tag version is immutable, treat that tag as equivalent to a SHA. Prefer immutable tag pins over raw SHAs because they stay readable, but add a workflow comment noting that the tag was verified immutable.
   - For high-risk or untrusted third-party actions without immutable tags, prefer a full commit SHA and include a comment or documentation of the corresponding release tag when useful.
   - Avoid adding new third-party actions without explicit user consent. If an external action would be convenient, ask first and explain the supply-chain risk.
5. Validate workflow schemas after edits if a local task exists, for example `task validate:file -- .github/workflows/ci.yml`.

## Rules

- Do not assume `@vN` is latest. Verify upstream first.
- Do not use floating branch refs like `@main` or `@master` for external actions unless explicitly requested.
- Do not downgrade from an exact patch/SHA pin to a major tag unless explicitly requested.
- Do not replace an existing SHA pin with a tag unless GitHub's API verifies the tag is immutable or the user explicitly requests it. If using an immutable tag, add a comment documenting that verification.
- Do not introduce a new third-party action silently. Prefer built-in shell commands or official GitHub actions when possible, and ask before adding third-party actions.
- Mention verified upstream latest versions in the final response when version changes were made.
- If an action has no releases, use a specific tag if available; otherwise consider a commit SHA.

## Examples

- `uses: actions/checkout@v5` with latest release `v6.0.2`: prefer `actions/checkout@v6.0.2`; use `@v6` only when latest-major pinning is requested.
- `uses: jdx/mise-action@v3` with latest release `v4.0.1`: prefer `jdx/mise-action@v4.0.1`; use `@v4` only when latest-major pinning is requested.
- `uses: docker/login-action@v3`: check latest `docker/login-action` release; if already on latest exact patch or accepted major pin, leave unchanged.
