defmodule Glerl.Core.Parser do
  import Glerl.Core.DayOfYearConversion

  @spec input_str_to_lines(String.t()) :: list(String.t())
  def input_str_to_lines(input_str) do
    [_head1, _head2 | lines] = String.trim(input_str) |> String.split("\n")

    lines
    |> Enum.map(fn line ->
      String.trim(line)
      |> String.split(" ")
      |> Enum.filter(fn item -> String.length(item) > 0 end)
    end)
    |> Enum.filter(fn [item1 | _rest] -> item1 == "4" end)
  end

  def line_to_typed_line([_id, year, doy, utc, temp_c, speed, gusts, direction]) do
    [
      String.to_integer(year),
      String.to_integer(doy),
      utc,
      String.to_float(temp_c),
      String.to_float(speed),
      String.to_float(gusts),
      String.to_integer(direction),
      nil
    ]
  end

  def line_to_typed_line([_id, year, doy, utc, temp_c, speed, gusts, direction, humidity]) do
    [
      String.to_integer(year),
      String.to_integer(doy),
      utc,
      String.to_float(temp_c),
      String.to_float(speed),
      String.to_float(gusts),
      String.to_integer(direction),
      String.to_float(humidity)
    ]
  end

  def typed_list_to_datapoint([year, doy, utc, temp_c, speed, gusts, direction, humidity]) do

    date = day_of_year_to_date(year, doy)

    hour = utc |> String.slice(0, 2) |> String.to_integer()
    minute = utc |> String.slice(2, 4) |> String.to_integer()
    time = Time.new!(hour, minute, 0, 0)

    timestamp = DateTime.new!(date, time, "Etc/UTC")

    %Glerl.Core.Datapoint{
      timestamp: timestamp,
      temp_c: temp_c,
      speed: speed,
      gusts: gusts,
      direction: direction,
      humidity: humidity
    }
  end

  @spec parse(String.t()) :: list(%Glerl.Core.Datapoint{})
  def parse(input_str) do
    input_str_to_lines(input_str)
    # |> IO.inspect(limit: :infinity)
    |> Enum.map(&line_to_typed_line/1)
    |> Enum.map(&typed_list_to_datapoint/1)
  end
end
