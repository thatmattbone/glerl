defmodule Glerl.Core.Parser do
  import Glerl.Core.Conversion
  import Glerl.Core.DayOfYearConversion

  @spec input_str_to_lines(String.t()) :: list(String.t())
  def input_str_to_lines(input_str) do
    # skip the first two lines with headers...
    [_head1, _head2 | lines] = input_str |> String.trim() |> String.split("\n")

    lines
      |> Enum.map(&String.split(&1))
      |> Enum.filter(fn [first_item | _]->  # years post 2010 have header info periodically mixed into the data so we filter that out...
        case Integer.parse(first_item) do
          # if the first item in the list cannot be parsed as an integer, skip it.
          {_, ""} ->
              true
          _ ->
            false
          end
      end)
  end

  def line_to_typed_line([station_id, year, doy, utc, temp_c, speed, gusts, direction]) do
    [
      String.to_integer(station_id),
      String.to_integer(year),
      String.to_integer(doy),
      utc,
      String.to_float(temp_c),
      String.to_float(speed) |> meters_per_second_to_knots(),
      String.to_float(gusts) |> meters_per_second_to_knots(),
      String.to_integer(direction),
      nil
    ]
  end

  def line_to_typed_line([station_id, year, doy, utc, temp_c, speed, gusts, direction, humidity]) do
    [
      String.to_integer(station_id),
      String.to_integer(year),
      String.to_integer(doy),
      utc,
      String.to_float(temp_c),
      String.to_float(speed) |> meters_per_second_to_knots(),
      String.to_float(gusts) |> meters_per_second_to_knots(),
      String.to_integer(direction),
      String.to_float(humidity)
    ]
  end

  def typed_list_to_datapoint([station_id, year, doy, utc, temp_c, speed, gusts, direction, humidity]) do
    date = day_of_year_to_date(year, doy)

    hour = utc |> String.slice(0, 2) |> String.to_integer()
    minute = utc |> String.slice(2, 4) |> String.to_integer()
    time = Time.new!(hour, minute, 0, 0)

    timestamp = DateTime.new!(date, time, "UTC")
    chicago_timestamp = DateTime.shift_zone!(timestamp, "America/Chicago")
      |> DateTime.truncate(:second)

    %Glerl.Core.Datapoint{
      station_id: station_id,
      timestamp: chicago_timestamp,
      temp_c: temp_c,
      speed: speed,
      gusts: gusts,
      direction: direction,
      humidity: humidity
    }
  end

  @spec parse(String.t()) :: list(Glerl.Core.Datapoint.t())
  def parse(input_str) do
    input_str_to_lines(input_str)
      |> Enum.map(&line_to_typed_line/1)
      |> Enum.map(&typed_list_to_datapoint/1)
  end
end
