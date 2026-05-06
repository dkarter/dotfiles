# Safe Refactoring Workflow

Use this reference before replacing code across files or when deciding whether `ex_ast` is warranted.

## Use `ex_ast` When

- Matching Elixir syntax shape is safer than text matching.
- Piped and direct forms should be treated as equivalent.
- Captures need to be reused in a replacement.
- Matches need to be restricted by function/module/test context.
- Multiple patterns should be scanned in one pass.
- A syntax-aware diff is useful to distinguish moves from edits.

## Do Not Use `ex_ast` When

- A literal grep gives the exact needed result.
- The task is one obvious edit in one known file.
- The project does not already depend on `ex_ast`.
- The change depends on runtime semantics, macro expansion, type information, or alias resolution.
- The desired replacement needs nuanced manual edits around each match.

## Replacement Checklist

1. Confirm dependency or task availability.
2. Search with `--limit 20` and inspect examples.
3. Narrow scope by path first, then by relationship filters.
4. Count matches before replacement when scope is broad.
5. Run replacement with `--dry-run`.
6. Apply replacement only after the preview is correct.
7. Review `git diff`.
8. Clean up generated AST rendering issues, especially captured field access rendered as zero-arity calls.
9. Run `mix format` or the repository formatter.
10. Run targeted tests or compile checks.

## Pattern Refinement Examples

Start broad, then add structure:

```bash
mix ex_ast.search --limit 20 'IO.inspect(...)' lib/
mix ex_ast.search --limit 20 --not-inside 'test _ do ... end' 'IO.inspect(...)' .
mix ex_ast.search --count --not-inside 'test _ do ... end' 'IO.inspect(...)' .
```

Use captures for safer replacement:

```bash
mix ex_ast.replace --dry-run 'dbg(expr)' 'expr' lib/
```

Use context to avoid changing setup or tests:

```bash
mix ex_ast.replace --dry-run --inside 'defp _ do ... end' 'Repo.get!(mod, id)' 'Repo.get(mod, id)' lib/
```

Use programmatic queries when relationship filters stack up:

```elixir
import ExAST.Query

query =
  from(["def _ do ... end", "defp _ do ... end"])
  |> where(contains("Repo.transaction(_)"))
  |> where(not contains("dbg(...)") and not contains("IO.inspect(...)"))

ExAST.search("lib/", query)
```

## Working With Generated Changes

- Prefer `--dry-run` and inspect output before writing.
- If the replacement handles 90% of the change but creates awkward formatting or edge cases, use it only for search guidance and patch manually.
- Watch for captured access like `membership.account_id` rendering as `membership.account_id()` in replacements; fix it manually before verification.
- If a broad replacement touched unrelated user changes, do not revert blindly. Inspect the diff and ask if there is a direct conflict.
- After replacement, format first, then review, then test.
