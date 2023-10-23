defmodule Glerl.CoreTest do
  use ExUnit.Case
  doctest Glerl.Core

  test "greets the world" do
    assert Glerl.Core.hello() == :world
  end
end
