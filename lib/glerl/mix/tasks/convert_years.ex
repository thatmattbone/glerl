defmodule Mix.Tasks.Glerl.ConvertYears do
  @moduledoc "Convert and clean the (already downloaded) by-year archive into a by-day archive."
  @shortdoc "Converts & cleans the glerl archive"

  use Mix.Task

  require Logger

  @impl Mix.Task
  def run(_) do
    Glerl.Archive.Converter.convert_all_years(2010..2010)
  end
end
