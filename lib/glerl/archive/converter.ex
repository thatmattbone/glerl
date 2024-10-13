defmodule Glerl.Archive.Converter do
  require Logger

  alias Glerl.Archive

  @spec parse_and_clean_year(integer()) :: list(Glerl.Core.Datapoint.t())
  def parse_and_clean_year(year) do
    Archive.Downloader.read_file_for_year(year)
      |> Glerl.Core.Parser.parse()
      |> Enum.sort_by(&(&1.timestamp), DateTime)
      |> Enum.dedup()
      # fill in missing data in data_points...
  end

  # @spec convert_year(integer()) :: String.t()
  # def convert_year(year) do
  #     parsed_year = parse_and_clean_year(year)
  #       |> Enum.group_by(fn d -> d.timestamp |> DateTime.to_date() end)

  #   for {date, data_points} <- parsed_year do
  #

  #     File.write(filename_for_date(date), Jason.encode!(data_points))

  #     nil
  #   end
  # end

  def convert_all_years() do
    # for year <- Archive.Downloader.min_year()..Archive.Downloader.max_year() do
    all_years_parsed_and_cleaned =
      for year <- 2010..2010 do
        Logger.info("reading and parsing file for year #{year}")

        parse_and_clean_year(year)
      end

    all_years_parsed_and_cleaned = Enum.flat_map(all_years_parsed_and_cleaned, fn x -> x end)

    Logger.info("cleaned and flatten all the year data")

    all_years_parsed_and_cleaned = all_years_parsed_and_cleaned |>
      Enum.group_by(fn d -> d.timestamp |> DateTime.to_date() end)

    Logger.info("grouped all the year data")
    for {date, data_points} <- all_years_parsed_and_cleaned do
      # need a way to convert date to datetime start/end vals that respects CST CDT
      {:ok, start_time_naive} = DateTime.new(date, ~T[00:00:00.000])
      {:ok, end_time_naive} = DateTime.new(date, ~T[23:58:00.000])

      start_time = start_time_naive |> DateTime.from_naive!("America/Chicago") |> DateTime.truncate(:second)
      end_time = end_time_naive |> DateTime.from_naive!("America/Chicago") |> DateTime.truncate(:second)

      Logger.info("fixing and writing out data for date #{date} from #{start_time} --> #{end_time}")

      IO.inspect(length(data_points))
      [first, second | _] = data_points
      IO.inspect(first)
      IO.inspect(second)

      fixed_datapoints = Archive.Cleaner.fix_data(data_points, start_time, end_time)
      IO.inspect(length(fixed_datapoints))

      # File.write(Archive.Reader.filename_for_date(date), Jason.encode!(data_points))

      date
    end

    nil
  end


end
