# Customization Guide

Use these defaults as a baseline, then tune by project needs.

## `mise.toml`

- Keep tool channels on `latest` for greenfield repos.
- Pin versions for long-lived repos where reproducibility matters.
- Keep `committed` on `"github:crate-ci/committed"` so mise pulls native release assets on arm64 hosts.
- Keep `pitchfork` for local orchestration and `fnox` for secrets unless the repo already standardizes on alternatives.

## `fnox.toml`

- Default provider should stay `onepass` when the team uses 1Password.
- Keep keychain fallback for `OP_SERVICE_ACCOUNT_TOKEN` for local development.
- Commit only provider and key mappings, never secret values.

## Mise built-in tasks

- Add language-specific tasks (`test`, `lint`, `typecheck`) under `[tasks.*]` in `mise.toml`.
- Keep `fmt-check` lightweight and deterministic.
- For app commands that need secrets, prefer `fnox run -- <command>` inside task `run` entries.

## `dprint.json`

- Keep the plugin set minimal for faster startup.
- Add or remove plugins based on file types in the repository.
- Adjust `lineWidth` only if the team already has a standard.

## `hk.pkl`

- Keep `commit-msg` for conventional commits when team policy requires it.
- Prefer file-aware builtins for checks and formatters.
- Keep `pre-push` checks fast; avoid long-running test suites there.

## `committed.toml`

- Keep `style = "conventional"` for semantic history.
- Increase `subject_length` only if the team already uses longer subjects.

## `renovate.json`

- Include only when the repository already uses Renovate or plans to.
- Extend additional presets only after confirming org-level preferences.
