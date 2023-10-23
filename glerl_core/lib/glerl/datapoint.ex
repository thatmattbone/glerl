defmodule Glerl.Core.Datapoint do
  defstruct [
    :year,
    :doy,
    :utc,
    :temp_c,
    :speed,
    :gusts,
    :direction,
    :humidity
  ]
end
