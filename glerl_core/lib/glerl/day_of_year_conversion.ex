defmodule Glerl.Core.DayOfYearConversion do

  # to be a leap year, the number of the year must be divisible by four except for end of the century years (1900, 2000, 2100) which must be divisible by 400

  def day_of_year_to_date(year, day_of_year) when rem(year, 4) == 0 and rem(year, 100) != 0 do
    {month, day} = convert_leap_year(day_of_year)

    Date.new(year, month, day)
  end

  def day_of_year_to_date(year, day_of_year) when rem(year, 400) == 0 and rem(year, 100) == 0 do
    {month, day} = convert_leap_year(day_of_year)

    Date.new(year, month, day)
  end

  def day_of_year_to_date(year, day_of_year) do
    {month, day} = convert_regular_year(day_of_year)

    Date.new(year, month, day)
  end

  def convert_leap_year(day_of_year) when day_of_year >= 1   and day_of_year <= 31,  do: {1,  day_of_year - 0  }
  def convert_leap_year(day_of_year) when day_of_year >= 32  and day_of_year <= 60,  do: {2,  day_of_year - 31 }
  def convert_leap_year(day_of_year) when day_of_year >= 61  and day_of_year <= 91,  do: {3,  day_of_year - 60 }
  def convert_leap_year(day_of_year) when day_of_year >= 92  and day_of_year <= 121, do: {4,  day_of_year - 91 }
  def convert_leap_year(day_of_year) when day_of_year >= 122 and day_of_year <= 152, do: {5,  day_of_year - 121}
  def convert_leap_year(day_of_year) when day_of_year >= 153 and day_of_year <= 182, do: {6,  day_of_year - 152}
  def convert_leap_year(day_of_year) when day_of_year >= 183 and day_of_year <= 213, do: {7,  day_of_year - 182}
  def convert_leap_year(day_of_year) when day_of_year >= 214 and day_of_year <= 244, do: {8,  day_of_year - 213}
  def convert_leap_year(day_of_year) when day_of_year >= 245 and day_of_year <= 274, do: {9,  day_of_year - 244}
  def convert_leap_year(day_of_year) when day_of_year >= 275 and day_of_year <= 305, do: {10, day_of_year - 274}
  def convert_leap_year(day_of_year) when day_of_year >= 306 and day_of_year <= 335, do: {11, day_of_year - 305}
  def convert_leap_year(day_of_year) when day_of_year >= 336 and day_of_year <= 366, do: {12, day_of_year - 335}


  def convert_regular_year(day_of_year) when day_of_year >= 1   and day_of_year <= 31,  do: {1,  day_of_year - 0  }
  def convert_regular_year(day_of_year) when day_of_year >= 32  and day_of_year <= 59,  do: {2,  day_of_year - 31 }
  def convert_regular_year(day_of_year) when day_of_year >= 60  and day_of_year <= 90,  do: {3,  day_of_year - 59 }
  def convert_regular_year(day_of_year) when day_of_year >= 91  and day_of_year <= 120, do: {4,  day_of_year - 90 }
  def convert_regular_year(day_of_year) when day_of_year >= 121 and day_of_year <= 151, do: {5,  day_of_year - 120}
  def convert_regular_year(day_of_year) when day_of_year >= 152 and day_of_year <= 181, do: {6,  day_of_year - 151}
  def convert_regular_year(day_of_year) when day_of_year >= 182 and day_of_year <= 212, do: {7,  day_of_year - 181}
  def convert_regular_year(day_of_year) when day_of_year >= 213 and day_of_year <= 243, do: {8,  day_of_year - 212}
  def convert_regular_year(day_of_year) when day_of_year >= 244 and day_of_year <= 273, do: {9,  day_of_year - 243}
  def convert_regular_year(day_of_year) when day_of_year >= 274 and day_of_year <= 304, do: {10, day_of_year - 273}
  def convert_regular_year(day_of_year) when day_of_year >= 305 and day_of_year <= 334, do: {11, day_of_year - 304}
  def convert_regular_year(day_of_year) when day_of_year >= 335 and day_of_year <= 365, do: {12, day_of_year - 334}

end
