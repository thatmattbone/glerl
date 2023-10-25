defmodule Glerl.Realtime.Poller do
  use GenServer

  require Logger

  @poll_every 30 * 1000  # 30 seconds

  def start_link(state) do
    Logger.info("GlerlPoller.start_link/1 #{inspect(state)}")

    # server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(init_arg) do
    Logger.info("GlerlPoller.init/1 #{inspect(init_arg)}")

    send(self(), :poll)

    {:ok, init_arg}
  end

  def handle_info(:poll, state) do
    Logger.info("...doing my polling work...")

    todays_data = Glerl.Realtime.Downloader.fetch_todays_file()
    IO.inspect(todays_data)

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :poll, @poll_every)
  end
end
