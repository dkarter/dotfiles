# Customization Guide

Use these defaults as a baseline, then tune by project needs.

## `mise.toml`

- Keep tool channels on `latest` for greenfield repos.
- Pin versions for long-lived repos where reproducibility matters.

## `Taskfile.yml` and `taskfiles/ci.yml`

- Add language-specific tasks (`test`, `lint`, `typecheck`) in `Taskfile.yml`.
- Keep `ci:fmt:check` lightweight and deterministic.

## `dprint.json`

- Keep the plugin set minimal for faster startup.
- Add or remove plugins based on file types in the repository.
- Adjust `lineWidth` only if the team already has a standard.

## `lefthook.yml`

- Keep `commit-msg` for conventional commits when team policy requires it.
- Keep `pre-push` checks fast; avoid long-running test suites there.

## `committed.toml`

- Keep `style = "conventional"` for semantic history.
- Increase `subject_length` only if the team already uses longer subjects.

## `renovate.json`

- Include only when the repository already uses Renovate or plans to.
- Extend additional presets only after confirming org-level preferences.
