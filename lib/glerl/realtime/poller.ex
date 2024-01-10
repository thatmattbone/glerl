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
    
    Kernel.send(self(), :init_state)

    {:ok, buffer}
  end

  @impl true
  def handle_info(:init_state, state) do
    yesterdays_data = case Glerl.Realtime.Downloader.fetch_yesterdays_file() do 
      {:ok, yesterdays_data} -> yesterdays_data
      {:error, status_code} ->
        Logger.error("initializing yesterday's data failed, got status_code: #{status_code}")
        []
    end

    todays_data = case Glerl.Realtime.Downloader.fetch_todays_file() do 
      {:ok, todays_data} -> todays_data
      {:error, status_code} ->
        Logger.error("initializing today's data failed, got status_code: #{status_code}")
        []
    end

    new_state = state
      |> BoundedMapBuffer.push_all(yesterdays_data)
      |> BoundedMapBuffer.push_all(todays_data)

    Process.send_after(self(), :poll, @poll_every)

    Logger.info("state has been initialized")

    {:noreply, new_state}
  end

  @impl true
  def handle_info(:poll, state) do
    Logger.info("doing my polling work...")

    new_state = case Glerl.Realtime.Downloader.fetch_todays_file() do
      {:ok, todays_data} ->
        update_buffer(state, todays_data)
      {:error, status_code} ->
        Logger.error("polling work failed, got status_code: #{status_code}")
        state
    end

    Process.send_after(self(), :poll, @poll_every)

    {:noreply, new_state}
  end

  @impl true
  def handle_info(msg, state) do
    Logger.error("Unexpected message in Glerl.Realtime.Poller.handle_info: #{inspect(msg)}")
    {:noreply, state}
  end

  defp update_buffer(current_buffer = %BoundedMapBuffer{}, _todays_data = []) do
    Logger.warning("received empty `todays_data` in update_buffer.")
    current_buffer
  end

  defp update_buffer(current_buffer = %BoundedMapBuffer{}, todays_data) do
    Logger.info("updating buffer")

    current_top = current_buffer |> BoundedMapBuffer.peek()
    Logger.info("current_top: #{inspect(current_top)}")

    data_to_add = todays_data
      |> Enum.reverse()
      |> Enum.take_while(fn datapoint -> DateTime.after?(datapoint.timestamp, current_top.timestamp) end)
      |> Enum.reverse()

    if length(data_to_add) > 0 do
      Logger.info("going to add: #{inspect(data_to_add)}")
      BoundedMapBuffer.push_all(current_buffer, data_to_add)
    else
      current_buffer
    end
  end

  # calls for sending along state data to clients
  @impl true
  def handle_call(:latest, _from, state) do
    {:reply, BoundedMapBuffer.peek(state), state}
  end

  @impl true
  def handle_call({:latest, count}, _from, state) when is_integer(count) and count > 0 do
    latest = state
      |> BoundedMapBuffer.to_list()
      |> Enum.reverse()
      |> Enum.slice(0, count)

    {:reply, latest, state}
  end

  @impl true
  def handle_call(:die, _from, state) do
    {:stop, "killing myself", state}
  end

  @impl true
  def handle_call(msg, _from, state) do
    Logger.error("Unexpected message in Glerl.Realtime.Poller.handle_call: #{inspect(msg)}")
    {:reply, :error, state}
  end
end
