defmodule MecabTest do
  use ExUnit.Case
  doctest Mecab

  test "greets the world" do
    assert Mecab.hello() == :world
  end
end
