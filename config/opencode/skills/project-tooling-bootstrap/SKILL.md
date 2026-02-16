---
name: project-tooling-bootstrap
description: 'Bootstrap a repository with the Toolkit baseline developer tooling: mise, Task, dprint, lefthook, committed, and gitleaks. Use when a user asks to add or standardize local tooling, Git hooks, formatting checks, or commit-message linting in a new or existing project. Applies to polyglot repos that need repeatable local setup and pre-push quality checks.'
---

# Project Tooling Bootstrap

Apply a ready-made tooling baseline to a target project using the templates in `assets/template/`.

## Workflow

1. Inspect the target repository layout and confirm where root config files should live.
2. Apply templates with `scripts/install_toolkit.sh`.
3. Install tools and hooks in the target repository.
4. Run formatting and checks to verify setup.

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
- Global scope: `~/.config/opencode/skills/project-tooling-bootstrap/`

## What Gets Added

Core files copied to the target repository:

- `mise.toml`
- `Taskfile.yml`
- `taskfiles/ci.yml`
- `dprint.json`
- `lefthook.yml`
- `committed.toml`

Optional file:

- `renovate.json`

## Post-Install Commands

Run in the target repository:

```bash
mise install
lefthook install
task fmt
task ci:fmt:check
```

If commits should be conventionally linted, verify `committed` runs via a test commit message or existing commit hook flow.

## Idempotence Checks

Use this flow when validating repeated runs:

1. Run `bash scripts/install_toolkit.sh /path/to/project` once and confirm files are copied.
2. Run it again without flags and confirm output is only `ok` or `skip` lines.
3. Optionally run with `--force` to confirm differing files are intentionally updated.

## Customization Guidance

Read `references/customization.md` when the target project needs non-default plugin versions, extra Task tasks, or different hook gates.
