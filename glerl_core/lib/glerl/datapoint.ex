defmodule Glerl.Core.Datapoint do
  defstruct [
    :timestamp,
    :temp_c,
    :speed,
    :gusts,
    :direction,
    :humidity
  ]

  @type t :: %__MODULE__{
    timestamp: DateTime.t(),
    temp_c: float(),
    speed: float(),
    gusts: float(),
    direction: integer(),
    humidity: float()
  }
end
