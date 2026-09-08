---
name: project-tooling-bootstrap
description: 'Bootstrap a repository with the Toolkit baseline developer tooling: mise, dprint, lefthook, committed, gitleaks, pitchfork, and fnox. Use when a user asks to add or standardize local tooling, Git hooks, formatting checks, commit-message linting, local command orchestration, or secrets handling in a new or existing project. Applies to polyglot repos that need repeatable local setup and pre-push quality checks.'
---

# Project Tooling Bootstrap

Apply a ready-made tooling baseline to a target project using the templates in `assets/template/`.

## Workflow

1. Inspect the target repository layout and confirm where root config files should live.
2. Apply templates with `scripts/install_toolkit.sh`.
3. Install tools and hooks in the target repository.
4. Run formatting and checks to verify setup.

## Tool Application Rules

Use these defaults when applying the baseline in a target repository:

- Keep `committed` on `"github:crate-ci/committed"` to prefer native release assets on arm64 hosts.
- Keep `pitchfork` available for local command orchestration. See `https://pitchfork.jdx.dev`.
- Keep `fnox` available for secrets handling and secret-backed command execution.
- Install `fnox.toml` at the repository root unless the project already has a standardized secrets config.
- Default `fnox.toml` provider should be `onepass` (1Password) with keychain fallback for local token storage.
- Use mise built-in tasks as the default task runner.
- Keep `#:schema https://mise.jdx.dev/schema/mise.json` at the top of `mise.toml` for Taplo validation and completion.

When wiring commands/tasks:

- Wrap commands that need credentials with `fnox run -- <command>`.
- Use `pitchfork` for multi-command local workflows when orchestration is needed.
- Never commit secret values. Commit `fnox.toml` templates and keys only.

Example app run with fnox:

```bash
fnox run -- npm run dev
```

Baseline mise tasks:

```toml
[tasks.fmt]
description = "Formats all supported files"
run = "dprint fmt"

[tasks.fmt-check]
description = "Checks formatting and fails on differences"
run = "dprint check"
```

Default `fnox.toml` template:

```toml
default_provider = "onepass"

[providers]
onepass = { type = "1password", vault = "fnox" }
keychain = { type = "keychain", service = "fnox" }

[secrets]
OP_SERVICE_ACCOUNT_TOKEN = { provider = "keychain", value = "OP_SERVICE_ACCOUNT_TOKEN" }
```

## Quick Start

Run from this skill directory:

```bash
bash scripts/install_toolkit.sh /path/to/project
```

Optional flags:

- `--with-renovate`: include `renovate.json`
- `--force`: overwrite existing files instead of skipping them

The installer is idempotent: re-running without `--force` only copies missing files, reports `ok` for matching files, and leaves differing files untouched.

## Add To OpenCode

From the repository root, install this skill to OpenCode with the Vercel Skills CLI:

```bash
npx skills add ./project-tooling-bootstrap -a opencode
```

Install globally instead of project-local:

```bash
npx skills add ./project-tooling-bootstrap -a opencode -g
```

If you do not use the CLI, copy the skill directory manually to one of these paths:

- Project scope: `.agents/skills/project-tooling-bootstrap/`
- Global scope: `~/.agents/skills/project-tooling-bootstrap/`

## What Gets Added

Core files copied to the target repository:

- `mise.toml`
- `dprint.json`
- `lefthook.yml`
- `committed.toml`
- `fnox.toml`

Optional file:

- `renovate.json`

## Post-Install Commands

Run in the target repository:

```bash
mise install
lefthook install
mise run fmt
mise run fmt-check
```

If commits should be conventionally linted, verify `committed` runs via a test commit message or existing commit hook flow.

For local orchestration and secrets handling, verify `pitchfork` and `fnox` are installed after `mise install`.

## Idempotence Checks

Use this flow when validating repeated runs:

1. Run `bash scripts/install_toolkit.sh /path/to/project` once and confirm files are copied.
2. Run it again without flags and confirm output is only `ok` or `skip` lines.
3. Optionally run with `--force` to confirm differing files are intentionally updated.

## Customization Guidance

Read `references/customization.md` when the target project needs non-default plugin versions, extra mise tasks, or different hook gates.
