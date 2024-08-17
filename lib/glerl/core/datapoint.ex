defmodule Glerl.Core.Datapoint do

  @derive Jason.Encoder
  defstruct [
    :station_id,
    :timestamp,
    :temp_c,
    :speed,
    :gusts,
    :direction,
    :humidity
  ]

  @type t :: %__MODULE__{
    station_id: integer(),
    timestamp: DateTime.t(),
    temp_c: float(),
    speed: float(),
    gusts: float(),
    direction: integer(),
    humidity: float()
  }
end
