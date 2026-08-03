---
name: plan-local-storage
description: Persist plans under .plans and safely open any existing file in Neovim in the caller's current Herdr tab or tmux window. Use when a user asks to save a plan, open a plan, open or show a file in Neovim, or hand a file off to their editor.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Plan Local Storage

Focus on plan persistence and editor handoff. Do not prescribe planning methodology or document structure.

User-provided context:

$ARGUMENTS

## Workflow

For any request to open an existing file, immediately run the helper with its absolute path and report its output. Do not
repeat pane discovery or improvise editor commands.

```bash
zsh ~/.agents/skills/plan-local-storage/scripts/open_in_nvim.zsh <absolute-existing-file>
```

For plan persistence:

1. Ensure `.plans/` exists in the current project root.
2. Create a plan bundle directory at `.plans/<plan-short-slug>/`
3. Choose storage mode:
   - Single-file plan: save to `plan.md` inside the bundle directory.
   - Multi-file plan: save an entry file `index.md` and add supporting files as needed.
4. Use deterministic filenames for multi-file plans: `01-<slug>.md`, `02-<slug>.md`, `03-<slug>.md`.
5. Open `plan.md` for single-file mode, or `index.md` for multi-file mode with the helper above.
6. Return the saved path(s) and the helper's exact result.

## Storage Rules

- Store plan files only under `.plans/` for the current project.
- Keep existing plan files unless the user asked to overwrite.
- Favor single-file mode by default.
- Switch to multi-file mode when the plan naturally splits into distinct tracks or phases.
- In multi-file mode, keep `index.md` as the table of contents and links to each part file.

## Neovim Handoff Behavior

- Always use `open_in_nvim.zsh`; never use `herdr pane run`, repeat its pane discovery, or send editor input directly.
- In Herdr, the helper searches only the caller's workspace and tab. It reuses one editor, creates one when none exists,
  and fails rather than guessing when multiple editors exist.
- `pane run` is used only to launch Neovim in a newly created shell pane, never to send input to a running editor.
- Otherwise, in tmux, it searches only the caller pane's current window.
- It sends raw mode-escape keys, literal Ex text, and Enter to an existing editor.
- It uses a new editor tab so a modified current buffer remains loaded and unchanged.
- Report the helper's concise `opened`, `skipped`, or `error` result without retrying in another workspace or tab.
