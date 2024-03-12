defmodule Glerl.Core.Conversion do

  @spec meters_per_second_to_knots(number()) :: float()
  def meters_per_second_to_knots(meters_per_sec) do
    meters_per_sec * 1.943844
  end

  # convert degrees to 16 point compass rose directions.
  @spec degrees_to_direction(number()) :: String.t()
  def degrees_to_direction(degrees) when degrees >= 0      and degrees <  11.25, do: "N"
  def degrees_to_direction(degrees) when degrees >= 11.25  and degrees <  33.75, do: "NNE"
  def degrees_to_direction(degrees) when degrees >= 33.75  and degrees <  56.25, do: "NE"
  def degrees_to_direction(degrees) when degrees >= 56.25  and degrees <  78.75, do: "ENE"
  def degrees_to_direction(degrees) when degrees >= 78.75  and degrees < 101.25, do: "E"
  def degrees_to_direction(degrees) when degrees >= 101.25 and degrees < 123.75, do: "ESE"
  def degrees_to_direction(degrees) when degrees >= 123.75 and degrees < 146.25, do: "SE"
  def degrees_to_direction(degrees) when degrees >= 146.25 and degrees < 168.75, do: "SSE"
  def degrees_to_direction(degrees) when degrees >= 168.75 and degrees < 191.25, do: "S"
  def degrees_to_direction(degrees) when degrees >= 191.25 and degrees < 213.75, do: "SSW"
  def degrees_to_direction(degrees) when degrees >= 213.75 and degrees < 236.25, do: "SW"
  def degrees_to_direction(degrees) when degrees >= 236.25 and degrees < 258.75, do: "WSW"
  def degrees_to_direction(degrees) when degrees >= 258.75 and degrees < 281.25, do: "W"
  def degrees_to_direction(degrees) when degrees >= 281.25 and degrees < 303.75, do: "WNW"
  def degrees_to_direction(degrees) when degrees >= 303.75 and degrees < 326.25, do: "NW"
  def degrees_to_direction(degrees) when degrees >= 326.25 and degrees < 348.75, do: "NNW"
  def degrees_to_direction(degrees) when degrees >= 348.75 and degrees <= 360,   do: "N"
end
