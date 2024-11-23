defmodule Mix.Tasks.Glerl.ConvertYears do
  @moduledoc "Convert and clean the (already downloaded) by-year archive into a by-day archive."
  @shortdoc "Converts & cleans the glerl archive"

  use Mix.Task

  require Logger

  alias Glerl.Archive.Downloader


  @spec get_year_range(list(String.t())) :: Range.t()
  def get_year_range([start_year, end_year]) do
    String.to_integer(start_year)..String.to_integer(end_year)
  end


  @spec get_year_range(list(String.t())) :: Range.t()
  def get_year_range([year]) do
    String.to_integer(year)..String.to_integer(year)
  end


  @spec get_year_range(list(String.t())) :: Range.t()
  def get_year_range([]) do
    Downloader.min_year()..Downloader.max_year()
  end


  @impl Mix.Task
  def run(args) do
    my_range = get_year_range(args)

    Glerl.Archive.Converter.convert_all_years(my_range)
  end
end
