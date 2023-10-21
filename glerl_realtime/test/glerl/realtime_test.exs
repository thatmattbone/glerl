defmodule Glerl.RealtimeTest do
  use ExUnit.Case
  doctest Glerl.Realtime

  test "greets the world" do
    assert Glerl.Realtime.hello() == :world
  end
end
