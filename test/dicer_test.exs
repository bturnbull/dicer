defmodule DicerTest do
  use ExUnit.Case
  doctest Dicer

  test "greets the world" do
    assert Dicer.hello() == :world
  end
end
