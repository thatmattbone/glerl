defmodule Glerl.Realtime.Downloader do
  require Logger

  # the format for these urls looks like:
  #   https://www.glerl.noaa.gov/metdata/chi/2022/20220909.04t.txt

  @spec get_todays_file_url() :: String.t()
  def get_todays_file_url() do
    {:ok, now_utc} = DateTime.now("UTC")

    now_str = Calendar.strftime(now_utc, "%Y%m%d")
    now_year_str = Calendar.strftime(now_utc, "%Y")

    "https://www.glerl.noaa.gov/metdata/chi/#{now_year_str}/#{now_str}.04t.txt"
  end


  @spec get_yesterdays_file_url() :: String.t()
  def get_yesterdays_file_url do
    {:ok, now_utc} = DateTime.now("UTC")

    yesterday_utc = DateTime.add(now_utc, -1 * 60 * 60 * 24, :second)

    yesterday_str = Calendar.strftime(yesterday_utc, "%Y%m%d")
    yesterday_year_str = Calendar.strftime(yesterday_utc, "%Y")

    "https://www.glerl.noaa.gov/metdata/chi/#{yesterday_year_str}/#{yesterday_str}.04t.txt"
  end


  @spec fetch_and_parse_file(String.t()) :: {:ok, list(%Glerl.Core.Datapoint{})} | {:error, integer}
  defp fetch_and_parse_file(file_url) do
    {:ok, {{_, status_code, _}, _headers, response_content}} = :httpc.request(file_url)

    Logger.info("fetched #{file_url} with status_code: #{status_code}")

    case status_code do
      200 ->
        response_content
          |> List.to_string()
          |> Glerl.Core.Parser.parse()

      _ ->
        {:error, status_code}
    end
  end


  @spec fetch_yesterdays_file() :: {:ok, list(%Glerl.Core.Datapoint{})} | {:error, integer}
  def fetch_yesterdays_file() do
    get_yesterdays_file_url() |> fetch_and_parse_file()
  end


  @spec fetch_todays_file() :: {:ok, list(%Glerl.Core.Datapoint{})} | {:error, integer}
  def fetch_todays_file() do
    get_todays_file_url() |> fetch_and_parse_file()
  end
end
