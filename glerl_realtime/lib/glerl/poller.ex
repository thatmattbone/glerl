defmodule Glerl.Realtime.Poller do
  use GenServer

  require Logger

  @poll_every 30 * 1000  # 30 seconds
  @buffer_size 720  # updates every two minutes, 720 is 24 hours of data

  def start_link(state) do
    Logger.info("Glerl.Realtime.Poller.start_link/1 #{inspect(state)}")

    # server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(init_arg) do
    Logger.info("Glerl.Realtime.Poller.init/1 #{inspect(init_arg)}")

    buffer = BoundedMapBuffer.new(@buffer_size)
    todays_data = Glerl.Realtime.Downloader.fetch_todays_file() |> Enum.reverse()
    buffer = buffer |> BoundedMapBuffer.push_all(todays_data)

    schedule_work()

    {:ok, buffer}
  end

  @impl true
  def handle_info(:poll, state) do
    Logger.info("doing my polling work... #{inspect(state)}")

    todays_data = Glerl.Realtime.Downloader.fetch_todays_file()
    new_state = update_buffer(state, todays_data)

    schedule_work()

    {:noreply, new_state}
  end

  @impl true
  def handle_info(msg, state) do
    Logger.error("Unexpected message in Glerl.Realtime.Poller.handle_info: #{inspect(msg)}")
    {:noreply, state}
  end

  @impl true
  def handle_call(:latest, _from, state) do
    {:reply, BoundedMapBuffer.peek(state), state}
  end

  @impl true
  def handle_call(msg, _from, state) do
    Logger.error("Unexpected message in Glerl.Realtime.Poller.handle_call: #{inspect(msg)}")
    {:reply, :error, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :poll, @poll_every)
  end

  defp update_buffer(current_buffer = %BoundedMapBuffer{}, todays_data = []) do
    Logger.warning("received empty `todays_data` in update_buffer.")
    current_buffer
  end

  defp update_buffer(current_buffer = %BoundedMapBuffer{}, todays_data = [first | rest])  do
    Logger.info("updating buffer")

    #BoundedMapBuffer.push()
    current_buffer
  end
end
