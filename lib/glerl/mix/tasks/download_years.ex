defmodule Mix.Tasks.Glerl.DownloadYears do
  @moduledoc "Download the per-year archives from glerl."
  @shortdoc "Downloads the glerl archive"

  use Mix.Task

  require Logger
  alias Glerl.Archive.Downloader

  @impl Mix.Task
  def run(_) do
    Downloader.fetch_all_years()
  end
end
