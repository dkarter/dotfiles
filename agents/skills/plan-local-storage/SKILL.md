---
name: plan-local-storage
description: Persist plans to local project storage under .plans and open the saved markdown file in an existing Neovim pane in the current Herdr tab or tmux window when available. Use when a user asks to save a plan, write a plan file locally, or open a saved plan in Neovim.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
argument-hint: '[plan title or purpose]'
---

# Plan Local Storage

Focus on plan persistence and editor handoff. Do not prescribe planning methodology or document structure.

User-provided context:

$ARGUMENTS

## Workflow

1. Ensure `.plans/` exists in the current project root.
2. Create a plan bundle directory at `.plans/<plan-short-slug>/`
3. Choose storage mode:
   - Single-file plan: save to `plan.md` inside the bundle directory.
   - Multi-file plan: save an entry file `index.md` and add supporting files as needed.
4. Use deterministic filenames for multi-file plans: `01-<slug>.md`, `02-<slug>.md`, `03-<slug>.md`.
5. Open `plan.md` for single-file mode, or `index.md` for multi-file mode.
6. After saving, run:

```bash
zsh ~/.agents/skills/plan-local-storage/scripts/open_in_nvim.zsh <absolute-path-to-entry-file>
```

7. Return the saved path(s) and whether the entry file was opened in Neovim.

## Storage Rules

- Store plan files only under `.plans/` for the current project.
- Keep existing plan files unless the user asked to overwrite.
- Favor single-file mode by default.
- Switch to multi-file mode when the plan naturally splits into distinct tracks or phases.
- In multi-file mode, keep `index.md` as the table of contents and links to each part file.

## Neovim Handoff Behavior

- If `HERDR_ENV=1`, search the current Herdr tab first, even if `$TMUX` is also set.
- Otherwise, if in tmux, search the current tmux window.
- If neither multiplexer is active or no pane runs `nvim`/`vim`, do nothing.
- If a matching pane exists, send `:edit <file>` to it.
