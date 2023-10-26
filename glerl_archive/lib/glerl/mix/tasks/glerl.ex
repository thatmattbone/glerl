defmodule Mix.Tasks.Glerl do
  use Mix.Task

  @impl Mix.Task
  def run(_) do
    IO.puts("starting")

    all_years =
      for year <- 2000..2020 do
        IO.puts(year)

        Glerl.Archive.Downloader.read_file_for_year(year)
        |> Glerl.Core.Parser.parse()
      end

    IO.puts("done with parsing")

    all_years_flat = Enum.flat_map(all_years, fn x -> x end)

    IO.puts(length(all_years_flat))
    # IO.inspect(DataParser.parse(result))
  end
end
