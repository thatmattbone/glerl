defmodule Glerl.Archive.Cleaner do
  require Logger

  @spec check_data(list(Glerl.Datapoint.t()), DateTime.t(), DateTime.t()) :: nil
  def check_data([]=_data_points, start_time, end_time) do
    if start_time != end_time do
      Logger.warning("start time: #{start_time} does not equal end time: #{end_time}")
    end

    nil
  end

  @spec check_data(list(Glerl.Datapoint.t()), DateTime.t(), DateTime.t()) :: nil
  def check_data([first, second | datapoints]=_data_points, start_time, end_time) do

    two_minutes_later = start_time |> DateTime.add(2, :minute)
    if first.timestamp != start_time or second.timestamp != two_minutes_later do
      Logger.warning("second timestamp #{second.timestamp} is not two minutes after first timestamp: #{first.timestamp}")
    end

    check_data([second | datapoints], two_minutes_later, end_time)
  end
end
