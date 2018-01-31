defmodule DicerTest do
  use ExUnit.Case

  @iterations 10000

  describe "roll/1" do

    test "3d6" do
      rolls =
        Enum.to_list(1..@iterations)
        |> Enum.map(fn _x -> Dicer.roll("3d6") end)

      assert Enum.all?(rolls, fn roll -> elem(roll, 0) == :ok end)
      assert Enum.all?(rolls, fn roll -> elem(roll, 1).roll >= 3 end)
      assert Enum.all?(rolls, fn roll -> elem(roll, 1).roll <= 18 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(Enum.at(elem(roll, 1).dice, 0)) >= 3 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(Enum.at(elem(roll, 1).dice, 0)) <= 18 end)
      assert Enum.all?(rolls, fn roll -> Regex.match?(~r/^\(\d \d \d\)$/, elem(roll, 1).expr) end)
    end

    test "1d2 + 97" do
      rolls =
        Enum.to_list(1..@iterations)
        |> Enum.map(fn _x -> Dicer.roll("1d2 + 97") end)

      assert Enum.all?(rolls, fn roll -> elem(roll, 0) == :ok end)
      assert Enum.all?(rolls, fn roll -> elem(roll, 1).roll >= 98 end)
      assert Enum.all?(rolls, fn roll -> elem(roll, 1).roll <= 99 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(Enum.at(elem(roll, 1).dice, 0)) >= 1 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(Enum.at(elem(roll, 1).dice, 0)) <= 2 end)
      assert Enum.all?(rolls, fn roll -> Enum.at(elem(roll, 1).dice, 1) == 97 end)
      assert Enum.all?(rolls, fn roll -> Regex.match?(~r/^\(\d\) \+ 97$/, elem(roll, 1).expr) end)
    end

    test "10d4 - 5" do
      rolls =
        Enum.to_list(1..@iterations)
        |> Enum.map(fn _x -> Dicer.roll("10d4 - 5") end)

      assert Enum.all?(rolls, fn roll -> elem(roll, 0) == :ok end)
      assert Enum.all?(rolls, fn roll -> elem(roll, 1).roll >= 5 end)
      assert Enum.all?(rolls, fn roll -> elem(roll, 1).roll <= 35 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(Enum.at(elem(roll, 1).dice, 0)) >= 10 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(Enum.at(elem(roll, 1).dice, 0)) <= 40 end)
      assert Enum.all?(rolls, fn roll -> Enum.at(elem(roll, 1).dice, 1) == 5 end)
      assert Enum.all?(rolls, fn roll -> Regex.match?(~r/^\((\d ){9}\d\) - 5$/, elem(roll, 1).expr) end)
    end

    test "d8 + 3d6" do
      rolls =
        Enum.to_list(1..@iterations)
        |> Enum.map(fn _x -> Dicer.roll("d8 + 3d6") end)

      assert Enum.all?(rolls, fn roll -> elem(roll, 0) == :ok end)
      assert Enum.all?(rolls, fn roll -> elem(roll, 1).roll >= 4 end)
      assert Enum.all?(rolls, fn roll -> elem(roll, 1).roll <= 26 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(Enum.at(elem(roll, 1).dice, 0)) >= 1 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(Enum.at(elem(roll, 1).dice, 0)) <= 8 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(Enum.at(elem(roll, 1).dice, 1)) >= 3 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(Enum.at(elem(roll, 1).dice, 1)) <= 18 end)
      assert Enum.all?(rolls, fn roll -> Regex.match?(~r/^\(\d\) \+ \(\d \d \d\)$/, elem(roll, 1).expr) end)
    end

    test "trash" do
      assert {:error, _} = Dicer.roll("trash")
    end
  end

  describe "dice/2" do

    test "5d20" do
      rolls =
        Enum.to_list(1..@iterations)
        |> Enum.map(fn _x -> Dicer.dice(5, 20) end)

      assert Enum.all?(rolls, fn roll -> Enum.sum(roll) >= 5 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(roll) <= 100 end)
    end

    test "1d2" do
      rolls =
        Enum.to_list(1..@iterations)
        |> Enum.map(fn _x -> Dicer.dice(1, 2) end)

      assert Enum.all?(rolls, fn roll -> Enum.sum(roll) >= 1 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(roll) <= 2 end)
    end

    test "1d100" do
      rolls =
        Enum.to_list(1..@iterations)
        |> Enum.map(fn _x -> Dicer.dice(1, 100) end)

      assert Enum.all?(rolls, fn roll -> Enum.sum(roll) >= 1 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(roll) <= 100 end)
    end
  end

  describe "dice/1" do

    test "5d20" do
      rolls =
        Enum.to_list(1..@iterations)
        |> Enum.map(fn _x -> Dicer.dice("5d20") end)

      assert Enum.all?(rolls, fn roll -> Enum.sum(roll) >= 5 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(roll) <= 100 end)
    end

    test "1d2" do
      rolls =
        Enum.to_list(1..@iterations)
        |> Enum.map(fn _x -> Dicer.dice("1d2") end)

      assert Enum.all?(rolls, fn roll -> Enum.sum(roll) >= 1 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(roll) <= 2 end)
    end

    test "1d100" do
      rolls =
        Enum.to_list(1..@iterations)
        |> Enum.map(fn _x -> Dicer.dice("1d100") end)

      assert Enum.all?(rolls, fn roll -> Enum.sum(roll) >= 1 end)
      assert Enum.all?(rolls, fn roll -> Enum.sum(roll) <= 100 end)
    end
  end
end
