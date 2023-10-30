defmodule Glerl.Core.DayOfYearConversion do

  def day_of_year_to_date(year, day_of_year) when rem(year, 4) == 0 do
    convert_leap_year(day_of_year)
  end

  def day_of_year_to_date(year, day_of_year) do
    convert_regular_year(day_of_year)
  end

  def convert_leap_year(day_of_year) when day_of_year >= 1   and day_of_year <= 31,  do: 1
  def convert_leap_year(day_of_year) when day_of_year >= 32  and day_of_year <= 60,  do: 2
  def convert_leap_year(day_of_year) when day_of_year >= 61  and day_of_year <= 91,  do: 3
  def convert_leap_year(day_of_year) when day_of_year >= 92  and day_of_year <= 121, do: 4
  def convert_leap_year(day_of_year) when day_of_year >= 122 and day_of_year <= 152, do: 5
  def convert_leap_year(day_of_year) when day_of_year >= 153 and day_of_year <= 182, do: 6
  def convert_leap_year(day_of_year) when day_of_year >= 183 and day_of_year <= 213, do: 7
  def convert_leap_year(day_of_year) when day_of_year >= 214 and day_of_year <= 244, do: 8
  def convert_leap_year(day_of_year) when day_of_year >= 245 and day_of_year <= 274, do: 9
  def convert_leap_year(day_of_year) when day_of_year >= 275 and day_of_year <= 305, do: 10
  def convert_leap_year(day_of_year) when day_of_year >= 306 and day_of_year <= 335, do: 11
  def convert_leap_year(day_of_year) when day_of_year >= 336 and day_of_year <= 366, do: 12


  def convert_regular_year(day_of_year) when day_of_year >= 1   and day_of_year <= 31,  do: 1
  def convert_regular_year(day_of_year) when day_of_year >= 32  and day_of_year <= 59,  do: 2
  def convert_regular_year(day_of_year) when day_of_year >= 60  and day_of_year <= 90,  do: 3
  def convert_regular_year(day_of_year) when day_of_year >= 91  and day_of_year <= 120, do: 4
  def convert_regular_year(day_of_year) when day_of_year >= 122 and day_of_year <= 152, do: 5
  def convert_regular_year(day_of_year) when day_of_year >= 152 and day_of_year <= 181, do: 6
  def convert_regular_year(day_of_year) when day_of_year >= 182 and day_of_year <= 212, do: 7
  def convert_regular_year(day_of_year) when day_of_year >= 213 and day_of_year <= 243, do: 8
  def convert_regular_year(day_of_year) when day_of_year >= 244 and day_of_year <= 273, do: 9
  def convert_regular_year(day_of_year) when day_of_year >= 274 and day_of_year <= 304, do: 10
  def convert_regular_year(day_of_year) when day_of_year >= 305 and day_of_year <= 334, do: 11
  def convert_regular_year(day_of_year) when day_of_year >= 335 and day_of_year <= 365, do: 12

end
