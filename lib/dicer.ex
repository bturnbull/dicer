defmodule Dicer do
  @moduledoc """
  Evaluate and roll an RPG dice expression.
  """

  @doc """
  Roll the result of an RPG dice expression.  Understands applying
  advantage or disadvantage by appending 'a' or 'd' to a dice
  expression.

  Returns `{:ok, %{roll:, dice:, expr:}`
  Returns `{:error, :invalid_expr}`

  ## Examples

      iex> Dicer.roll("3d6")
      %{roll: 13, dice: [[3, 4, 6]], expr: "(3 4 6)"}

      iex> Dicer.roll("2d8 + 5")
      %{roll: 12, dice: [[3, 4], 5], expr: "(3 4) + 5"}

      iex> Dicer.roll("d20a + 2")
      %{roll: 16, dice: [[11, 14], 2], expr: "(14 | 11) + 2"}

  """
  def roll(expr) do
    case :dice_lexer.string(to_charlist(expr)) do
      {:ok, tokens, _} ->
        {:ok, calc(tokens, %{roll: 0, dice: [], expr: ""})}
      {:error, _, _} ->
        {:error, :invalid_expr}
    end
  end

  @doc """
  Roll `count` dice of `sides` number of sides. Can also use an RPG
  expression.

  Returns `List`

  ## Examples

    iex> Dicer.dice(3, 6)
    [3, 4, 1]

    iex> Dicer.dice("3d6")
    [3, 6, 2]

  """
  def dice(count, sides) do
    Enum.to_list(1..count)
    |> Enum.map(fn _x -> (:rand.uniform(sides)) end)
  end

  def dice(expr) do
    [count, sides] =
      String.split(expr, "d", parts: 2)
      |> Enum.map(&(String.to_integer(&1)))
    dice(count, sides)
  end

  # Accumulate over the tokens returned by the :dice_lexer, producing:
  #
  #   %{
  #     roll: 14,              # final roll result
  #     expr: "(3 5 6)",       # individual dice results (String)
  #     dice: [3, 5, 6]        # individual dice results (List)
  #   }
  #
  defp calc([head | tail], accumulator) do
    case head do
      {:op, _, op} ->
        calc(tail, accumulate(%{op: op}, accumulator))
      {:int, _, int} ->
        calc(tail, accumulate(%{int: int}, accumulator))
      {:dice, _, expr} ->
        calc(tail, accumulate(%{dice: Enum.sort(dice(expr))}, accumulator))
      {:dice_advantage, _, expr} ->
        dice =
          [Enum.sort(dice(expr)), Enum.sort(dice(expr))]
          |> Enum.sort(&(Enum.sum(&1) >= Enum.sum(&2)))
        calc(tail, accumulate(%{dice_adv: dice}, accumulator))
      {:dice_disadvantage, _, expr} ->
        dice =
          [Enum.sort(dice(expr)), Enum.sort(dice(expr))]
          |> Enum.sort(&(Enum.sum(&1) <= Enum.sum(&2)))
        calc(tail, accumulate(%{dice_adv: dice}, accumulator))
    end
  end

  defp calc([], accumulator) do
    %{accumulator | expr: String.trim_leading(accumulator[:expr])}
  end

  defp accumulate(%{op: op}, acc) do
    %{
      roll: acc[:roll],
      op:   op,
      dice: acc[:dice],
      expr: Enum.join([acc[:expr], op], " ")
    }
  end

  defp accumulate(%{int: int}, acc) do
    roll = case acc[:op] do
      "-" ->
        acc[:roll] - int
      _ ->
        acc[:roll] + int
    end

    %{
      roll: roll,
      dice: Enum.reverse([int | Enum.reverse(acc[:dice])]),
      expr: Enum.join([acc[:expr], "#{int}"], " ")
    }
  end

  defp accumulate(%{dice: dice}, acc) do
    roll = case acc[:op] do
      "-" ->
        acc[:roll] - Enum.sum(dice)
      _ ->
        acc[:roll] + Enum.sum(dice)
    end

    %{
      roll: roll,
      dice: Enum.reverse([dice | Enum.reverse(acc[:dice])]),
      expr: Enum.join([acc[:expr], "(#{Enum.join(dice, " ")})"], " ")
    }
  end

  defp accumulate(%{dice_adv: dice}, acc) do
    selected = Enum.at(dice, 0)
    rejected = Enum.at(dice, 1)

    roll = case acc[:op] do
      "-" ->
        acc[:roll] - Enum.sum(selected)
      _ ->
        acc[:roll] + Enum.sum(selected)
    end

    %{
      roll: roll,
      dice: Enum.reverse([selected | Enum.reverse(acc[:dice])]),
      expr: Enum.join([acc[:expr], "(#{Enum.join(selected, " ")} | #{Enum.join(rejected, " ")})"], " ")
    }
  end
end
