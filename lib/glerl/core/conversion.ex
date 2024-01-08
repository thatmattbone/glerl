defmodule Glerl.Core.Conversion do
  def meters_per_second_to_knots(meters_per_sec) do
    meters_per_sec * 1.943844
  end
end
