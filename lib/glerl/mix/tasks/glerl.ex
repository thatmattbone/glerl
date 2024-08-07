defmodule Mix.Tasks.Glerl do
  use Mix.Task

  require Logger
  alias Glerl.Archive.Downloader

  @impl Mix.Task
  def run(_) do
    Downloader.fetch_all_years()

    all_years =
      for year <- Downloader.min_year()..Downloader.max_year() do
        Logger.info("reading and parsing file for year #{year}")

        Downloader.read_file_for_year(year)
          |> IO.inspect()
          |> Glerl.Core.Parser.parse()
      end



    all_years_flat = Enum.flat_map(all_years, fn x -> x end)
    Logger.info(length(all_years_flat))
    # IO.inspect(DataParser.parse(result))
  end
end
