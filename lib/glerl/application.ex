defmodule Glerl.Application do
  use Application

  require Logger

  @impl true
  def start(type, args) do
    Logger.info("Glerl.Application.start/2  #{inspect(type)}  #{inspect(args)}")

    Glerl.Realtime.Supervisor.start_link(%{})
    Glerl.Archive.Supervisor.start_link(%{})
  end
end
