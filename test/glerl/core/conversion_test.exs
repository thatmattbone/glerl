defmodule Glerl.Core.ConversionTest do
  use ExUnit.Case
  doctest Glerl.Core.Conversion

  test "meters per second to knots" do
    assert Glerl.Core.Conversion.meters_per_second_to_knots(5.0) == 9.71922
    assert Glerl.Core.Conversion.meters_per_second_to_knots(7.5) == 14.57883
  end
end
