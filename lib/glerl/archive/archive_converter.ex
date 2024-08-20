defmodule Glerl.Archive.ArchiveConverter do
  require Logger

  alias Glerl.Archive.Downloader
  alias Glerl.Archive.DataDir

  @spec filename_for_date(Date.t()) :: Sring.t()
  def filename_for_date(date) do
    month = String.pad_leading("#{date.month}", 2, "0")
    day = String.pad_leading("#{date.day}", 2, "0")

    DataDir.create_data_dir() <> "/" <> "#{date.year}_#{month}_#{day}.json"
  end

  @spec parse_and_clean_year(integer()) :: list(Glerl.Core.Datapoint.t())
  def parse_and_clean_year(year) do
    Downloader.read_file_for_year(year)
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
      for year <- Downloader.min_year()..Downloader.max_year() do
        Logger.info("reading and parsing file for year #{year}")

        parse_and_clean_year(year)
      end

    all_years_parsed_and_cleaned = Enum.flat_map(all_years_parsed_and_cleaned, fn x -> x end)

    Logger.info("cleaned and flatten all the year data")

    all_years_parsed_and_cleaned = all_years_parsed_and_cleaned |>
      Enum.group_by(fn d -> d.timestamp |> DateTime.to_date() end)

    Logger.info("grouped all the year data")
    for {date, data_points} <- all_years_parsed_and_cleaned do
      File.write(filename_for_date(date), Jason.encode!(data_points))

      date
    end

    nil
  end


end
