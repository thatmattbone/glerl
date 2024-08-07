defmodule Glerl.Archive.Downloader do
  require Logger

  @spec min_year() :: integer()
  def min_year() do
    2000
  end

  @spec max_year() :: integer()
  def max_year() do
    Date.utc_today().year - 1
  end

  @spec check_year!(integer()) :: nil
  def check_year!(year) do
    if year > max_year() do
      raise "the year #{year} is in the future."
    end

    if year < min_year() do
      raise "the year #{year} is before the year #{min_year()}."
    end

    nil
  end

  @spec filename_for_year(integer()) :: String.t()
  def filename_for_year(year) do
    check_year!(year)

    "chi#{year}.04t.txt"
  end

  @spec url_for_year(integer()) :: String.t()
  def url_for_year(year) do
    filename = filename_for_year(year)

    "https://www.glerl.noaa.gov/metdata/chi/archive/#{filename}"
  end

  @spec file_path_for_year(integer()) :: String.t()
  def file_path_for_year(year) do
    Glerl.Archive.DataDir.create_data_dir() <> "/" <> filename_for_year(year)
  end

  @spec fetch_file_for_year(integer()) :: nil
  def fetch_file_for_year(year) do
    # don't think we need this anymore since it's started in mix.exs
    # :ok = :ssl.start()
    # :ok = :inets.start()

    Logger.info("fetching file for year: #{year}")

    {:ok, {_status, _headers, response_content}} = :httpc.request(url_for_year(year))
    :ok = File.write(file_path_for_year(year), response_content)

    nil
  end

  @spec fetch_all_years() :: nil
  def fetch_all_years() do
    Logger.info("starting glerl downloader for years #{min_year()} to #{max_year()}.")

    for year <- min_year()..max_year() do
      if not File.exists?(file_path_for_year(year)) do
        fetch_file_for_year(year)
      else
        Logger.info("file for year #{year} already exists. will not fetch.")
      end
    end

    nil
  end

  @spec read_file_for_year(integer()) :: String.t()
  def read_file_for_year(year) do
    # if not File.exists?(file_path_for_year(year)) do
    #   fetch_file_for_year(year)
    # end

    File.read!(file_path_for_year(year))
  end
end
