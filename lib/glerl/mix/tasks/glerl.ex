defmodule Mix.Tasks.Glerl do
  use Mix.Task

  alias Glerl.Archive.Downloader

  @impl Mix.Task
  def run(_) do
    min_year = Downloader.min_year()
    max_year = Downloader.max_year()

    IO.puts("starting glerl downloder for years #{min_year} to #{max_year}.")

    all_years =
      for year <- min_year..max_year do
        IO.puts(year)

        Downloader.read_file_for_year(year)
          |> Glerl.Core.Parser.parse()
      end

    all_years_flat = Enum.flat_map(all_years, fn x -> x end)

    IO.puts(length(all_years_flat))
    # IO.inspect(DataParser.parse(result))
  end
end
