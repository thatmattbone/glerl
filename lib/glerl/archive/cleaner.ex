defmodule Glerl.Archive.Cleaner do
  require Logger

  alias Glerl.Archive

  @spec check_data(list(Glerl.Datapoint.t()), DateTime.t(), DateTime.t()) :: nil
  def check_data([]=_data_points, start_time, end_time) do
    if start_time != end_time do
      Logger.warning("start time: #{start_time} does not equal end time: #{end_time}")
    end

    nil
  end

  @spec check_data(list(Glerl.Datapoint.t()), DateTime.t(), DateTime.t()) :: nil
  def check_data([first, second]=_data_points, start_time, end_time) do

    two_minutes_later = start_time |> DateTime.add(2, :minute)

    if first.timestamp != start_time do
      Logger.warning("first time not equal to start time: #{first.timestamp} <> #{start_time}")
      # IO.inspect(first.timestamp, structs: false)
      # IO.inspect(start_time, structs: false)
    end

    if second.timestamp != two_minutes_later do
      Logger.warning("two minutes later is: #{two_minutes_later}")
      Logger.warning("second timestamp #{second.timestamp} is not two minutes after first timestamp: #{first.timestamp}")
    end

    if start_time != end_time do
      Logger.warning("start time: #{start_time} does not equal end time: #{end_time}")
    end

    nil
  end


  @spec check_data(list(Glerl.Datapoint.t()), DateTime.t(), DateTime.t()) :: nil
  def check_data([first, second | datapoints]=_data_points, start_time, end_time) do

    two_minutes_later = start_time |> DateTime.add(2, :minute)

    if first.timestamp != start_time do
      Logger.warning("first time not equal to start time: #{first.timestamp} <> #{start_time}")
      # IO.inspect(first.timestamp, structs: false)
      # IO.inspect(start_time, structs: false)
    end

    if second.timestamp != two_minutes_later do
      Logger.warning("two minutes later is: #{two_minutes_later}")
      Logger.warning("second timestamp #{second.timestamp} is not two minutes after first timestamp: #{first.timestamp}")
    end

    check_data([second | datapoints], two_minutes_later, end_time)
  end

  def test_a_day() do
    start_time = DateTime.from_naive!(~N[2023-04-11T00:00:00], "America/Chicago")
    end_time = DateTime.from_naive!(~N[2023-04-11T23:58:00], "America/Chicago")

    data = Archive.Reader.data_for_date(DateTime.to_date(start_time))
    #  |> Enum.slice(0, 10)

    check_data(data, start_time, end_time)
  end

  # DateTime.from_naive!(~N[2023-04-11T00:00:00], "America/Chicago")
end
