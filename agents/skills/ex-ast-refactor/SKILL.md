---
name: ex-ast-refactor
description: Search, analyze, and refactor Elixir code with `ex_ast` AST patterns in projects that already depend on `ex_ast`. Use only when syntax-aware matching, captures, pipe normalization, ancestor/child/sibling filters, multi-pattern scans, or dry-run AST replacements provide a clear benefit over regular grep/search and manual patches. Do not use for simple literal text searches or in projects that do not already contain `ex_ast`.
---

# ExAST Refactor

## Overview

Use `ex_ast` for Elixir refactors and investigations where AST structure matters: call shape, function context, matched captures, equivalent piped/direct calls, or safe batch replacements. Keep normal Glob/Grep/apply_patch as the default for simple text edits.

## Activation Gate

1. Confirm the project already has `ex_ast` before using it. Check `mix.exs`, `mix.lock`, or available mix tasks. Do not add `ex_ast` just to use this skill unless the user explicitly asks.
2. Use this skill only when AST semantics reduce risk or effort. Prefer plain Grep and patches for exact strings, one-off edits, documentation, config text, or non-Elixir files.
3. Prefer the CLI for quick searches and mechanical dry-run replacements. Prefer `mix run -e` or a scratch Elixir script when queries need `ExAST.Query`, capture guards, custom output, or multi-pattern analysis.
4. Always preview broad or write operations before modifying files.

## Core Workflow

1. Define the code shape in normal Elixir syntax. Use wildcards, captures, ellipsis, or relationship filters only when needed.
2. Run a limited search first, for example `mix ex_ast.search --limit 20 'IO.inspect(...)' lib/`.
3. Inspect representative matches and refine the pattern. Use `--inside`, `--not-inside`, `--contains`, or a query when context matters.
4. For replacements, run `mix ex_ast.replace --dry-run 'PATTERN' 'REPLACEMENT' PATH` first.
5. Apply the replacement only after the dry run matches the intended scope.
6. Run `mix format` or the repository formatting task after replacements because generated formatting may differ.
7. Verify with targeted tests, compile, or the repository's check task.

## Common Commands

```bash
mix ex_ast.search 'PATTERN' PATH
mix ex_ast.search --limit 20 --inside 'defp _ do ... end' 'Repo.get!(_, _)' lib/
mix ex_ast.replace --dry-run 'PATTERN' 'REPLACEMENT' PATH
mix ex_ast.replace 'dbg(expr)' 'expr' lib/
mix ex_ast.diff lib/old.ex lib/new.ex --summary
```

## Reference Files

- Read [Pattern Language](references/pattern-language.md) when designing or debugging `ex_ast` patterns.
- Read [Querying, CLI, and API](references/querying-cli-api.md) when context filters, capture guards, programmatic searches, or command options are needed.
- Read [Safe Refactoring Workflow](references/safe-refactoring-workflow.md) before making project-wide replacements or when deciding whether `ex_ast` is justified.

## Guardrails

- Avoid broad patterns like `_` unless using `--limit` or `--allow-broad` intentionally.
- Treat generated replacements as code changes, not text substitutions. Review the diff before finalizing.
- Do not rely on semantic alias expansion or macro expansion. `ex_ast` is syntax-aware, not a compiler.
- Captured remote or field access can render differently in replacements, such as `record.field()` instead of `record.field`. Review and clean up generated code.
- Replacement formatting may use `Macro.to_string/1`; run the project formatter afterward.
- Use apply_patch for manual cleanup around generated changes when the AST replacement is too broad or awkward.
