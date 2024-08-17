defmodule Glerl.Archive.ArchiveConverter do
  alias Glerl.Archive.Downloader
  alias Glerl.Archive.DataDir

  @spec filename_for_date(Date.t()) :: Sring.t()
  def filename_for_date(date) do
    month = String.pad_leading("#{date.month}", 2, "0")
    day = String.pad_leading("#{date.day}", 2, "0")

    DataDir.create_data_dir() <> "/" <> "#{date.year}_#{month}_#{day}.json"
  end

  @spec convert_year(integer()) :: String.t()
  def convert_year(year) do
    parsed_year = Downloader.read_file_for_year(year)
      |> Glerl.Core.Parser.parse()
      |> Enum.sort_by(&(&1.timestamp), DateTime)
      |> Enum.dedup()
      |> Enum.group_by(fn d -> d.timestamp |> DateTime.to_date() end)

    for {date, data_points} <- parsed_year do
      # fill in missing data in data_points...

      File.write(filename_for_date(date), Jason.encode!(data_points))

      nil
    end
  end
end
