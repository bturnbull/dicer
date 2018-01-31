# Dicer

Evaluate RPD dice notation and roll result.

## Examples

```elixir
iex> Dicer.roll("3d6")
{:ok, %{roll: 14, dice: [[3, 5, 6]], expr: "(3 5 6)"}}
iex> Dicer.roll("5d8 + 20")
{:ok, %{roll: 42, dice: [[1, 4, 4, 5, 6], 20], expr: "(1 4 4 5 6) + 20"}}
iex> Dicer.roll("3d6 + d8 - 2")
{:ok, %{roll: 8, dice: [[1 3 5], [1], 2], expr: "(1 3 5) + (1) - 2"}}
```

## To Use

```elixir
def deps do
  [
    {:dicer, git: "https://github.com/bturnbull/dicer.git", tag: "0.1.0"}
  ]
end
```
