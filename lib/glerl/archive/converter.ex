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
    all_years_parsed_and_cleaned =
      for year <- Archive.Downloader.min_year()..Archive.Downloader.max_year() do
        Logger.info("reading and parsing file for year #{year}")

        parse_and_clean_year(year)
      end

    all_years_parsed_and_cleaned = Enum.flat_map(all_years_parsed_and_cleaned, fn x -> x end)

    Logger.info("cleaned and flatten all the year data")

    all_years_parsed_and_cleaned = all_years_parsed_and_cleaned |>
      Enum.group_by(fn d -> d.timestamp |> DateTime.to_date() end)

    Logger.info("grouped all the year data")
    for {date, data_points} <- all_years_parsed_and_cleaned do
      File.write(Archive.Reader.filename_for_date(date), Jason.encode!(data_points))

      date
    end

    nil
  end


end
