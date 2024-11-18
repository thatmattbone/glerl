defmodule Mix.Tasks.Glerl.ConvertYears do
  @moduledoc "Convert and clean the (already downloaded) by-year archive into a by-day archive."
  @shortdoc "Converts & cleans the glerl archive"

  use Mix.Task

  require Logger

  @impl Mix.Task
  def run(_) do
    IO.puts("Hello, from Mix.Tasks.Glerl.ConvertYears")
  end
end
