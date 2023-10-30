defmodule Glerl.Core.Datapoint do
  defstruct [
    :timestamp,
    :temp_c,
    :speed,
    :gusts,
    :direction,
    :humidity
  ]
end
