# Pattern Language

Use this reference when designing `ex_ast` patterns. Patterns are valid Elixir expressions as strings or quoted expressions.

## Core Syntax

| Syntax              | Meaning                                                                              |
| ------------------- | ------------------------------------------------------------------------------------ |
| `_` or `_name`      | Wildcard. Matches any node and does not capture.                                     |
| `name`, `expr`, `x` | Capture. Matches any node and binds it by name.                                      |
| `...`               | Ellipsis. Matches zero or more nodes in argument lists, list items, or block bodies. |
| Other Elixir syntax | Literal match by AST shape.                                                          |

Repeated capture names require the same AST value in every position. Pattern `{a, a}` matches `{x, x}` but not `{x, y}`.

## Useful Shapes

```elixir
# Any IO.inspect arity
"IO.inspect(...)"

# Capture expression being debugged
"dbg(expr)"

# Function definitions with any body
"def run(_) do ... end"

# Multi-node contiguous sequence in a block
"a = Repo.get!(_, _); Repo.delete(a)"

# Partial struct/map matching
"%User{role: role}"
"%{name: name}"

# Module attributes
"@name Application.get_env(_, _)"
"@_ Application.get_env(_, _)"
```

## Pipe Normalization

`ex_ast` desugars pipes before matching. These patterns can match both direct and piped forms:

```elixir
"Enum.map(_, _)"
"_ |> Enum.map(_)"
"Enum.filter(_, _) |> Enum.map(_)"
```

Use this when refactoring APIs where a function may be called directly or via a pipe.

## Recipes

```elixir
# Potential bug: negative count
"Enum.take(_, -_)"

# Always-true comparison or duplicate tuple fields
"{a, a}"

# Specific success tuple
"{:ok, val}"

# Compile-time config reads
"@_ Application.get_env(_, _)"

# Function calls regardless of arity
"Logger.info(...)"
```

## Limitations

- Function-name wildcards are not supported; `def _(_)` does not match arbitrary function names.
- Alias handling is syntax-aware, not semantic. Do not assume macro or compiler expansion.
- Multi-node patterns require contiguous statements.
- Replacement formatting may change. Run the project formatter after replacements.
