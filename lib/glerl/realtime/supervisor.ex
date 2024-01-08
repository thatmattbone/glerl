defmodule Glerl.Realtime.Supervisor do
  use Supervisor

  require Logger

  def start_link(init_arg) do
    Logger.info("Glerl.Supervisor.start_link/1 #{inspect(init_arg)}")

    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(init_arg) do
    Logger.info("Glerl.Supervisor.init/1 #{inspect(init_arg)}")

    children = [
      Glerl.Realtime.Poller
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
