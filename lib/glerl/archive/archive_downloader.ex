defmodule Glerl.Archive.Downloader do
  @min_year 2000
  @max_year 2023

  @spec filename_for_year(integer()) :: String.t()
  def filename_for_year(year) when year >= @min_year and year < @max_year do
    "chi#{year}.04t.txt"
  end

  @spec url_for_year(integer()) :: String.t()
  def url_for_year(year) when year >= @min_year and year < @max_year do
    filename = filename_for_year(year)

    "https://www.glerl.noaa.gov/metdata/chi/archive/#{filename}"
  end

  @spec file_path_for_year(integer()) :: String.t()
  def file_path_for_year(year) when year >= @min_year and year < @max_year do
    Glerl.Archive.DataDir.create_data_dir() <> "/" <> filename_for_year(year)
  end

  @spec fetch_file_for_year(integer()) :: nil
  def fetch_file_for_year(year) when year >= @min_year and year < @max_year do
    :ssl.start()
    :inets.start()

    {:ok, {_status, _headers, response_content}} = :httpc.request(url_for_year(year))
    File.write(file_path_for_year(year), response_content)

    nil
  end

  @spec fetch_all_years() :: nil
  def fetch_all_years() do
    for year <- @min_year..@max_year, do: fetch_file_for_year(year)

    nil
  end

  @spec read_file_for_year(integer()) :: String.t()
  def read_file_for_year(year) when year >= @min_year and year < @max_year do
    if not File.exists?(file_path_for_year(year)) do
      fetch_file_for_year(year)
    end

    File.read!(file_path_for_year(year))
  end
end
