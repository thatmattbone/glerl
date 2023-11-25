defmodule Glerl.Realtime.Application do
  use Application

  require Logger

  @impl true
  def start(type, args) do
    Logger.info("Glerl.Realtime.Application.start/2  #{inspect(type)}  #{inspect(args)}")

    Glerl.Realtime.Supervisor.start_link(%{})
  end
end
