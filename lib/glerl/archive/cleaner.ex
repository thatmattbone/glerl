defmodule Glerl.Archive.Cleaner do
  require Logger

  alias Glerl.Archive

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


  # def fix_data([first, second, third | rest], start_time, end_time, fixed) do
  #   two_minutes_later = start_time |> DateTime.add(2, :minute)

  #   if first.timestamp == start_time do
  #     if second.timestamp == two_minutes_later do
  #       # this is the expected, normal case. everything looks good, keep on truckin'
  #       fix_data([second, third | rest], second.timestamp, end_time, [first | fixed])
  #     else
  #       diff = DateTime.diff(second.timestamp, first.timestamp, :minute)

  #       if diff <= 20 do  # less than a 20 minute diff, we just fill in the data with what was happening at the start time
  #         extra_datapoints = for i <- 2..(diff - 2)//2, into: [] do
  #           new_timestamp = DateTime.add(first.timestamp, i, :minute)

  #           %{first | timestamp: new_timestamp}
  #         end
  #         extra_datapoints = Enum.reverse(extra_datapoints)

  #         fixed = extra_datapoints ++ [first | fixed]
  #         fix_data([second, third | rest], second.timestamp, end_time, fixed)
  #       else
  #         # IO.puts("fuck")
  #         # IO.inspect(diff)
  #         # IO.inspect(second)
  #         # IO.inspect(start_time)
  #         # IO.inspect(end_time)
  #         nil
  #       end
  #     end
  #   end
  #   # implement me
  # end


  def fix_data([first, second | rest], start_time, end_time, fixed) do
    two_minutes_later = start_time |> DateTime.add(2, :minute)

    if first.timestamp == start_time do
      if second.timestamp == two_minutes_later do
        # this is the expected, normal case. everything looks good, keep on truckin'
        fix_data([second | rest], second.timestamp, end_time, [first | fixed])
      else
        diff = DateTime.diff(second.timestamp, first.timestamp, :minute)

        if diff <= 20 do  # less than a 20 minute diff, we just fill in the data with what was happening at the start time
          extra_datapoints = for i <- 2..(diff - 2)//2, into: [] do
            new_timestamp = DateTime.add(first.timestamp, i, :minute)

            %{first | timestamp: new_timestamp}
          end
          extra_datapoints = Enum.reverse(extra_datapoints)

          fixed = extra_datapoints ++ [first | fixed]
          fix_data([second | rest], second.timestamp, end_time, fixed)
        else
          # IO.puts("fuck")
          # IO.inspect(diff)
          # IO.inspect(second)
          # IO.inspect(start_time)
          # IO.inspect(end_time)
          nil
        end
      end
    end
  end


  def fix_data([first], _start_time, end_time, fixed) when first.timestamp == end_time do
    [first | fixed]
  end


  def fix_data([], _start_time, _end_time, fixed) do
    fixed
  end


  def fix_data(data_points, start_time, end_time) do
    fix_data(data_points, start_time, end_time, [])
      |> Enum.reverse()
  end


  def fix_data(data_points) do
    fix_data(data_points, List.first(data_points).timestamp, List.last(data_points).timestamp)
  end


  def fix_a_day() do
    start_time = DateTime.from_naive!(~N[2023-04-11T00:00:00], "America/Chicago")
    end_time = DateTime.from_naive!(~N[2023-04-11T23:58:00], "America/Chicago")

    data = Archive.Reader.data_for_date(DateTime.to_date(start_time))
    fixed = fix_data(data, start_time, end_time)

    check_data(fixed)

    nil
    # IO.inspect(List.last(fixed))
  end
end
