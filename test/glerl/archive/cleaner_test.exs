defmodule Glerl.Archive.CleanerTest do
  use ExUnit.Case
  doctest Glerl.Archive.Cleaner

  alias Glerl.Archive.Cleaner
  alias Glerl.Core.Datapoint

  test "fix empty list" do
    start_time = DateTime.from_naive!(~N[2022-05-11T10:00:00], "America/Chicago")
    end_time = DateTime.from_naive!(~N[2022-05-11T10:00:00], "America/Chicago")

    assert Cleaner.fix_data([], start_time, end_time) == []
  end

  test "fix two element list with small gap" do
    start_time = DateTime.from_naive!(~N[2011-05-11T10:00:00], "America/Chicago")
    end_time = DateTime.from_naive!(~N[2011-05-11T10:06:00], "America/Chicago")

    datapoints = [
      %Datapoint{
        station_id: 4,
        timestamp: start_time,
        temp_c: 20.0,
        speed: 10.4,
        gusts: 11.5,
        direction: 96,
        humidity: 55.5
      },
      %Datapoint{
        station_id: 4,
        timestamp: end_time,
        temp_c: 20.5,
        speed: 9.4,
        gusts: 11.1,
        direction: 98,
        humidity: 55.2
      }
    ]

    Cleaner.check_data(datapoints)

    fixed = Cleaner.fix_data(datapoints)
    #IO.inspect(fixed)

    assert length(fixed) == 4
    [a, b, c, d] = fixed

    assert a == List.first(datapoints)
    assert d == List.last(datapoints)

    assert b.timestamp == DateTime.from_naive!(~N[2011-05-11T10:02:00], "America/Chicago")
    assert %{a | timestamp: nil} == %{b | timestamp: nil}

    assert c.timestamp == DateTime.from_naive!(~N[2011-05-11T10:04:00], "America/Chicago")
    assert %{b | timestamp: nil} == %{c | timestamp: nil}
  end

  test "fix four element list with three small gaps" do
    start_time = DateTime.from_naive!(~N[2011-05-11T10:00:00], "America/Chicago")
    end_time = DateTime.from_naive!(~N[2011-05-11T10:30:00], "America/Chicago")

    datapoints = [
      %Datapoint{
        station_id: 4,
        timestamp: start_time,
        temp_c: 20.0,
        speed: 10.4,
        gusts: 11.5,
        direction: 96,
        humidity: 55.5
      },
      %Datapoint{
        station_id: 4,
        timestamp: DateTime.from_naive!(~N[2011-05-11T10:14:00], "America/Chicago"),
        temp_c: 21.0,
        speed: 11.4,
        gusts: 12.1,
        direction: 98,
        humidity: 52.5
      },
      %Datapoint{
        station_id: 4,
        timestamp: DateTime.from_naive!(~N[2011-05-11T10:18:00], "America/Chicago"),
        temp_c: 20.5,
        speed: 10.4,
        gusts: 11.5,
        direction: 94,
        humidity: 49.5
      },
      %Datapoint{
        station_id: 4,
        timestamp: end_time,
        temp_c: 20.5,
        speed: 9.4,
        gusts: 11.1,
        direction: 97,
        humidity: 48.2
      }
    ]

    Cleaner.check_data(datapoints)

    fixed = Cleaner.fix_data(datapoints)

    assert length(fixed) == 16
  end
end
