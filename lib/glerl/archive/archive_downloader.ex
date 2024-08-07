defmodule Glerl.Archive.Downloader do
  @min_year 2000

  @spec get_max_year() :: integer()
  def get_max_year() do
    Date.utc_today().year
  end

  @spec check_year!(integer()) :: nil
  def check_year!(year) do
    if year > get_max_year() do
      raise "the year #{year} is in the future."
    end

    nil
  end

  @spec filename_for_year(integer()) :: String.t()
  def filename_for_year(year) when year >= @min_year do
    check_year!(year)

    "chi#{year}.04t.txt"
  end

  @spec url_for_year(integer()) :: String.t()
  def url_for_year(year) when year >= @min_year do
    filename = filename_for_year(year)

    "https://www.glerl.noaa.gov/metdata/chi/archive/#{filename}"
  end

  @spec file_path_for_year(integer()) :: String.t()
  def file_path_for_year(year) when year >= @min_year do
    Glerl.Archive.DataDir.create_data_dir() <> "/" <> filename_for_year(year)
  end

  @spec fetch_file_for_year(integer()) :: nil
  def fetch_file_for_year(year) when year >= @min_year do
    :ok = :ssl.start()
    :ok = :inets.start()

    {:ok, {_status, _headers, response_content}} = :httpc.request(url_for_year(year))
    :ok = File.write(file_path_for_year(year), response_content)

    nil
  end

  @spec fetch_all_years() :: nil
  def fetch_all_years() do
    for year <- @min_year..get_max_year(), do: fetch_file_for_year(year)

    nil
  end

  @spec read_file_for_year(integer()) :: String.t()
  def read_file_for_year(year) when year >= @min_year do
    if not File.exists?(file_path_for_year(year)) do
      fetch_file_for_year(year)
    end

    File.read!(file_path_for_year(year))
  end
end
