defmodule Glerl.Core.DayOfYearConversionTest do
  use ExUnit.Case
  doctest Glerl.Core.DayOfYearConversion
  import Glerl.Core.DayOfYearConversion

  test "big range of years" do
    for year <- 1850..2350 do
      for day <- 1..365 do
        # IO.puts("#{year} #{day}")

        the_date = day_of_year_to_date(year, day)

        assert Date.day_of_year(the_date) == day
      end
    end
  end
end
