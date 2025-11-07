defmodule Glerl.Archive.Cleaner do
  require Logger

  alias Glerl.Archive

  # in 2015 there's about a week long gap in the data and this is when we switch from five minute samples to two minute samples.
  #
  #
  # 4 2015 338 1500    0.9     7.0     7.9     197
  # AirTemp WindSpd WindGst WindDir RelHum
  # ID Year DOY  UTC     C      m/s     m/s     deg      %
  #  4 2015 344 2106   14.2    14.3    17.1     191    55.5

  @spec check_data(list(Glerl.Datapoint.t()), DateTime.t(), DateTime.t()) :: nil
  def check_data([]=_data_points, start_time, end_time) do
    if start_time != end_time do
      Logger.warning("start time on empty list: #{start_time} does not equal end time: #{end_time}")
    end

    nil
  end

  @spec check_data(list(Glerl.Datapoint.t()), DateTime.t(), DateTime.t()) :: nil
  def check_data([first, second]=_data_points, start_time, end_time) do
    two_minutes_later = start_time |> DateTime.add(2, :minute)

    if first.timestamp != start_time do
      Logger.warning("first time not equal to start time: #{first.timestamp} <> #{start_time}")
    end

    if second.timestamp != two_minutes_later do
      Logger.warning("two minutes later is: #{two_minutes_later}")
      Logger.warning("second timestamp #{second.timestamp} is not two minutes after first timestamp: #{first.timestamp}")
    end

    if second.timestamp != end_time do
      Logger.warning("last timestamp in the list: #{second.timestamp} does not equal end time: #{end_time}")
    end

    nil
  end

  @spec check_data(list(Glerl.Datapoint.t()), DateTime.t(), DateTime.t()) :: nil
  def check_data([first, second | datapoints]=_data_points, start_time, end_time) do
    two_minutes_later = start_time |> DateTime.add(2, :minute)

    if first.timestamp != start_time do
      Logger.warning("first time not equal to start time: #{first.timestamp} <> #{start_time}")
    end

    if second.timestamp != two_minutes_later do
      Logger.warning("second timestamp #{second.timestamp} is not two minutes after first timestamp: #{first.timestamp}")
    end

    check_data([second | datapoints], second.timestamp, end_time)
  end

  @spec check_data(list(Glerl.Datapoint.t())) :: nil
  def check_data(datapoints) do
    check_data(datapoints, List.first(datapoints).timestamp, List.last(datapoints).timestamp)
  end


  def check_a_day() do
    start_time = DateTime.from_naive!(~N[2023-04-11T00:00:00], "America/Chicago")
    end_time = DateTime.from_naive!(~N[2023-04-11T23:58:00], "America/Chicago")

    data = Archive.Reader.data_for_date(DateTime.to_date(start_time))

    check_data(data, start_time, end_time)
  end


  defp _fill_data_gap(base_datapoint, diff, expected_gap, initial_time_to_add) when diff <= 20 do  # less than a 20 minute diff, we just fill in the data with what was happening at the start time
    extra_datapoints = for i <- initial_time_to_add..(diff - expected_gap)//expected_gap, into: [] do
      new_timestamp = DateTime.add(base_datapoint.timestamp, i, :minute)

      %{base_datapoint | timestamp: new_timestamp}
    end

    Enum.reverse(extra_datapoints)
  end

  defp _fill_data_gap(base_datapoint, diff, expected_gap, initial_time_to_add) do
    extra_datapoints = for i <- initial_time_to_add..(diff - expected_gap)//expected_gap, into: [] do
      new_timestamp = DateTime.add(base_datapoint.timestamp, i, :minute)

      %{base_datapoint | timestamp: new_timestamp, speed: 0.0, gusts: 0.0}  # zero out speed and gusts because gap is so large.
    end

    Enum.reverse(extra_datapoints)
  end


  def fill_data_gap(base_datapoint, diff, expected_gap, inclusive \\ false) do
    case inclusive do
      true -> _fill_data_gap(base_datapoint, diff, expected_gap, 0)
      _ -> _fill_data_gap(base_datapoint, diff, expected_gap, expected_gap)
    end
  end


  def get_expected_gap([first, second, third | _rest]) do
    expected_gap = min(DateTime.diff(second.timestamp, first.timestamp, :minute), DateTime.diff(third.timestamp, second.timestamp, :minute))

    case expected_gap do
      2  -> 2
      5  -> 5
      15 -> 5
      _ -> raise "Unexpected gap of #{expected_gap} minutes between #{second.timestamp} and #{first.timestamp}"
    end
  end


  def fix_data([], _start_time, _end_time, _expected_gap, fixed) do
    fixed
  end

  def fix_data([first], _start_time, end_time, _expected_gap, fixed) when first.timestamp == end_time do
    [first | fixed]
  end

  def fix_data([first, second | rest], start_time, end_time, expected_gap, fixed) do
    n_minutes_later = start_time |> DateTime.add(expected_gap, :minute)

    if first.timestamp == start_time do
      if second.timestamp == n_minutes_later do
        # this is the expected, normal case. everything looks good, keep on truckin'
        fix_data([second | rest], second.timestamp, end_time, expected_gap, [first | fixed])
      else
        diff = DateTime.diff(second.timestamp, first.timestamp, :minute)

        extra_datapoints = fill_data_gap(first, diff, expected_gap)

        fixed = extra_datapoints ++ [first | fixed]

        fix_data([second | rest], second.timestamp, end_time, expected_gap, fixed)
      end
    else
      diff = DateTime.diff(first.timestamp, start_time, :minute)

      Logger.warning("start time diff of #{diff} minutes. #{start_time} <> #{first.timestamp}")

      # need to fix this. we need to fill the gap between the expected start_time and first.timestamp
      # using the wind/temp info from the second data point
      extra_datapoints = fill_data_gap(%{first | timestamp: start_time}, diff, expected_gap, true)
      # extra_datapoints |> IO.inspect()
      fixed = extra_datapoints ++ [first | fixed]

      fix_data([second | rest], second.timestamp, end_time, expected_gap, fixed)
    end
  end

  def fix_data([first], _start_time, end_time, expected_gap, fixed) do  # we have a gap at the end of our data...
    diff = DateTime.diff(end_time, first.timestamp, :minute)

    extra_datapoints = fill_data_gap(first, diff, expected_gap)

    extra_datapoints ++ [first | fixed]
  end

  def fix_data(data_points=[], _start_time, _end_time) do
    data_points
  end

  def fix_data(data_points, start_time, end_time) do
    expected_gap = get_expected_gap(data_points)

    fix_data(data_points, start_time, end_time, expected_gap, [])
      |> Enum.reverse()
  end

  def fix_data(data_points=[]) do
    data_points
  end

  def fix_data(data_points) do
    fix_data(data_points, List.first(data_points).timestamp, List.last(data_points).timestamp)
  end


  def fix_a_day() do
    # start_time = DateTime.from_naive!(~N[2023-04-11T00:00:00], "America/Chicago")
    # end_time = DateTime.from_naive!(~N[2023-04-11T23:58:00], "America/Chicago")

    # start_time = DateTime.from_naive!(~N[2008-01-06T00:00:00], "America/Chicago")
    # end_time = DateTime.from_naive!(~N[2008-01-06T23:58:00], "America/Chicago")

    start_time = DateTime.from_naive!(~N[2010-12-20T00:00:00], "America/Chicago")
    end_time   = DateTime.from_naive!(~N[2010-12-20T23:58:00], "America/Chicago")

    data = Archive.Reader.data_for_date(DateTime.to_date(start_time))
    IO.inspect(length(data))
    [first, second | _] = data
    IO.inspect(first)
    IO.inspect(second)
    IO.inspect(end_time)

    #List.first(data) |> IO.inspect()
    #List.last(data) |> IO.inspect()
    #start_time |> IO.inspect()

    # check_data(data)

    # fixed = fix_data(data, start_time, end_time)
    # IO.inspect(length(fixed))
    # fixed |> IO.inspect(limit: :infinity)

    # List.first(fixed) |> IO.inspect()
    # List.last(fixed) |> IO.inspect()

    # Enum.slice(fixed, 0, 20) |> IO.inspect()

    nil
  end
end
