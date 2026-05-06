# Querying, CLI, and API

Use this reference when a pattern needs context, relationship filters, capture guards, or programmatic control.

## Contents

- [CLI Search](#cli-search)
- [CLI Replace](#cli-replace)
- [Query API](#query-api)
- [Capture Guards](#capture-guards)
- [Programmatic API](#programmatic-api)
- [Diff](#diff)

## CLI Search

```bash
mix ex_ast.search 'PATTERN' PATH [OPTIONS]
```

Common options:

| Option                                                                                                              | Purpose                                                    |
| ------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| `--count`                                                                                                           | Print match count only.                                    |
| `--limit N`                                                                                                         | Stop after N matches. Use for first-pass searches.         |
| `--allow-broad`                                                                                                     | Allow broad patterns like `_`. Avoid unless intentional.   |
| `--inside PATTERN`                                                                                                  | Only match inside ancestors matching pattern.              |
| `--not-inside PATTERN`                                                                                              | Reject matches inside ancestors matching pattern.          |
| `--parent PATTERN` / `--not-parent PATTERN`                                                                         | Filter by direct semantic parent.                          |
| `--ancestor PATTERN` / `--not-ancestor PATTERN`                                                                     | Filter by any semantic ancestor.                           |
| `--has-child PATTERN` / `--not-has-child PATTERN`                                                                   | Filter by direct children.                                 |
| `--contains PATTERN` / `--not-contains PATTERN`                                                                     | Filter by descendants.                                     |
| `--follows`, `--precedes`, `--immediately-follows`, `--immediately-precedes`                                        | Filter by sibling relationship.                            |
| `--first`, `--last`, `--nth N`                                                                                      | Filter by sibling position.                                |
| `--comment TEXT`, `--comment-before TEXT`, `--comment-after TEXT`, `--comment-inside TEXT`, `--comment-inline TEXT` | Filter by associated comments. Use `/.../` for regex text. |

Examples:

```bash
mix ex_ast.search 'IO.inspect(...)' lib/
mix ex_ast.search --inside 'defp _ do ... end' 'Repo.get!(_, _)' lib/
mix ex_ast.search --not-inside 'test _ do ... end' 'dbg(expr)' .
mix ex_ast.search --count '@_ Application.get_env(_, _)' lib/ config/
```

## CLI Replace

```bash
mix ex_ast.replace 'PATTERN' 'REPLACEMENT' PATH [OPTIONS]
```

Use `--dry-run` before writing. Captures from the pattern can be reused in the replacement.

```bash
mix ex_ast.replace --dry-run 'dbg(expr)' 'expr' lib/
mix ex_ast.replace --dry-run 'IO.inspect(expr)' 'Logger.debug(inspect(expr))' lib/
mix ex_ast.replace 'dbg(expr)' 'expr' lib/
```

Relationship filters available to search also apply to replace.

## Query API

Use `ExAST.Query` when matching depends on relationships or capture guards beyond simple CLI filters.

```elixir
import ExAST.Query

query =
  from("def _ do ... end")
  |> where(contains("Repo.transaction(_)"))
  |> where(not contains("IO.inspect(...)"))

ExAST.search("lib/", query)
```

Navigation changes the current selection:

```elixir
from("defmodule _ do ... end")
|> find("IO.inspect(_)")

from("defmodule _ do ... end")
|> find_child("def _ do ... end")
```

Predicates filter the current selection:

```elixir
from("IO.inspect(value)")
|> where(inside("def _ do ... end"))
|> where(not parent("if _ do ... end"))
```

Common predicates: `contains/1`, `has_child/1`, `inside/1`, `parent/1`, `follows/1`, `precedes/1`, `immediately_follows/1`, `immediately_precedes/1`, `first/0`, `last/0`, `nth/1`, `any/1`, and `all/1`.

## Capture Guards

Use `^capture` inside `where/2` to inspect captured AST values.

```elixir
import ExAST.Query

query =
  from("left == right")
  |> where(^left == ^right)
```

```elixir
query =
  from("def handle(event, _) do ... end")
  |> where(^event == :click or ^event == :keydown)
```

Any Elixir expression can be used in guards, including `match?/2`, `is_atom/1`, comparisons, and function calls.

## Programmatic API

Use programmatic calls with `mix run -e` or temporary scripts when CLI output is not enough.

```elixir
ExAST.search("lib/**/*.ex", "IO.inspect(...)")
ExAST.search("test/", "IO.inspect(_)", inside: "test _ do ... end")
ExAST.replace("lib/**/*.ex", "dbg(expr)", "expr", dry_run: true)
ExAST.search_many("lib/", %{get_env: "@_ Application.get_env(_, _)", dbg_call: "dbg(expr)"})
```

`ExAST.Patcher` works on source strings, AST nodes, or Sourceror zippers:

```elixir
ExAST.Patcher.find_all(source, "IO.inspect(_)")
ExAST.Patcher.find_many(source, inspect_call: "IO.inspect(expr)", debug_call: "dbg(expr)")
ExAST.Patcher.replace_all(source, "dbg(expr)", "expr")
```

Match results include file/source, line or range data, and captures depending on the API used.

## Diff

Use syntax-aware diffing when comparing generated alternatives or validating that a move was not a behavioral rewrite.

```bash
mix ex_ast.diff FILE1 FILE2 --summary
mix ex_ast.diff FILE1 FILE2 --json
```

Programmatic API:

```elixir
result = ExAST.diff(old_source, new_source)
ExAST.diff_files("lib/old.ex", "lib/new.ex")
```
