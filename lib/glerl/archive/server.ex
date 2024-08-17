defmodule Glerl.Archive.Server do
  use GenServer

  require Logger
  # alias Glerl.Archive.Downloader

  def start_link(state) do
    Logger.info("Glerl.Archive.Server.start_link/1 #{inspect(state)}")

    # server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(init_arg) do
    Logger.info("Glerl.Archive.Server.init/1 #{inspect(init_arg)}")


    # move all this to an init function or something
    # Downloader.fetch_all_years()

    # all_years =
    #   for year <- Downloader.min_year()..Downloader.max_year() do
    #     Logger.info("reading and parsing file for year #{year}")

    #     Downloader.read_file_for_year(year)
    #       |> Glerl.Core.Parser.parse()
    #   end

    all_years = []

    {:ok, all_years}
  end
end
