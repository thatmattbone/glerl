defmodule Glerl.Archive.Server do
  use GenServer

  require Logger

  def start_link(state) do
    Logger.info("Glerl.Archive.Server.start_link/1 #{inspect(state)}")

    # server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(init_arg) do
    Logger.info("Glerl.Archive.Server.init/1 #{inspect(init_arg)}")

    {:ok, %{}}
  end
end
