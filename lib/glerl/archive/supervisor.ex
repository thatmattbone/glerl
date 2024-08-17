defmodule Glerl.Archive.Supervisor do
  use Supervisor

  require Logger

  def start_link(init_arg) do
    Logger.info("Glerl.Archive.Supervisor.start_link/1 #{inspect(init_arg)}")

    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(init_arg) do
    Logger.info("Glerl.Archive.Supervisor.init/1 #{inspect(init_arg)}")

    children = [
      Glerl.Archive.Server
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
