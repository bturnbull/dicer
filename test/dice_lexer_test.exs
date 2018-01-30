defmodule DiceLexerTest do
  use ExUnit.Case

  test "d20" do
    assert {:ok, [{:dice, 1, "1d20"}], 1} = :dice_lexer.string('d20')
  end

  test "1d20" do
    assert {:ok, [{:dice, 1, "1d20"}], 1} = :dice_lexer.string('1d20')
  end

  test "2d20" do
    assert {:ok, [{:dice, 1, "2d20"}], 1} = :dice_lexer.string('2d20')
  end

  test "d6" do
    assert {:ok, [{:dice, 1, "1d6"}], 1} = :dice_lexer.string('d6')
  end

  test "1d6" do
    assert {:ok, [{:dice, 1, "1d6"}], 1} = :dice_lexer.string('1d6')
  end

  test "2d6" do
    assert {:ok, [{:dice, 1, "2d6"}], 1} = :dice_lexer.string('2d6')
  end

  test "d20a" do
    assert {:ok, [{:dice_advantage, 1, "1d20"}], 1} = :dice_lexer.string('d20a')
  end

  test "1d20a" do
    assert {:ok, [{:dice_advantage, 1, "1d20"}], 1} = :dice_lexer.string('1d20a')
  end

  test "2d20a" do
    assert {:ok, [{:dice_advantage, 1, "2d20"}], 1} = :dice_lexer.string('2d20a')
  end

  test "d20d" do
    assert {:ok, [{:dice_disadvantage, 1, "1d20"}], 1} = :dice_lexer.string('d20d')
  end

  test "1d20d" do
    assert {:ok, [{:dice_disadvantage, 1, "1d20"}], 1} = :dice_lexer.string('1d20d')
  end

  test "2d20d" do
    assert {:ok, [{:dice_disadvantage, 1, "2d20"}], 1} = :dice_lexer.string('2d20d')
  end

  test "d20 + 4" do
    assert {:ok, [{:dice, 1, "1d20"}, {:op, 1, "+"}, {:int, 1, 4}], 1} = :dice_lexer.string('d20 + 4')
  end

  test "1d20 + 4" do
    assert {:ok, [{:dice, 1, "1d20"}, {:op, 1, "+"}, {:int, 1, 4}], 1} = :dice_lexer.string('1d20 + 4')
  end

  test "2d20 + 4" do
    assert {:ok, [{:dice, 1, "2d20"}, {:op, 1, "+"}, {:int, 1, 4}], 1} = :dice_lexer.string('2d20 + 4')
  end

  test "2d20+4" do
    assert {:ok, [{:dice, 1, "2d20"}, {:op, 1, "+"}, {:int, 1, 4}], 1} = :dice_lexer.string('2d20+4')
  end

  test "2d20+ 4" do
    assert {:ok, [{:dice, 1, "2d20"}, {:op, 1, "+"}, {:int, 1, 4}], 1} = :dice_lexer.string('2d20+ 4')
  end

  test "2d20 +4" do
    assert {:ok, [{:dice, 1, "2d20"}, {:op, 1, "+"}, {:int, 1, 4}], 1} = :dice_lexer.string('2d20 +4')
  end

  test "2d6 - 1" do
    assert {:ok, [{:dice, 1, "2d6"}, {:op, 1, "-"}, {:int, 1, 1}], 1} = :dice_lexer.string('2d6 - 1')
  end

  test "2d6- 1" do
    assert {:ok, [{:dice, 1, "2d6"}, {:op, 1, "-"}, {:int, 1, 1}], 1} = :dice_lexer.string('2d6- 1')
  end

  test "2d6 -1" do
    assert {:ok, [{:dice, 1, "2d6"}, {:op, 1, "-"}, {:int, 1, 1}], 1} = :dice_lexer.string('2d6 -1')
  end

  test "d20a + 2" do
    assert {:ok, [{:dice_advantage, 1, "1d20"}, {:op, 1, "+"}, {:int, 1, 2}], 1} = :dice_lexer.string('d20a + 2')
  end

  test "d20d + 2" do
    assert {:ok, [{:dice_disadvantage, 1, "1d20"}, {:op, 1, "+"}, {:int, 1, 2}], 1} = :dice_lexer.string('d20d + 2')
  end

  test "5d8 + 2d4 + 16" do
    assert {:ok, [{:dice, 1, "5d8"}, {:op, 1, "+"}, {:dice, 1, "2d4"}, {:op, 1, "+"}, {:int, 1, 16}], 1} = :dice_lexer.string('5d8 + 2d4 + 16')
  end

  test "1d100" do
    assert {:ok, [{:dice, 1, "1d100"}], 1} = :dice_lexer.string('d100')
  end

  test "0d100" do
    assert {:error, _, _} = :dice_lexer.string('0d100')
  end

  test "2d0" do
    assert {:error, _, _} = :dice_lexer.string('2d0')
  end

  test "1d100 + 0" do
    assert {:error, _, _} = :dice_lexer.string('1d100 + 0')
  end

  test "trash" do
    assert {:error, _, _} = :dice_lexer.string('trash')
  end
end
