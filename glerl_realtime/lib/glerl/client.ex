defmodule Glerl.Realtime.Client do

  def latest() do
    GenServer.call(Glerl.Realtime.Poller, :latest)
  end

  def latest(count) do
    GenServer.call(Glerl.Realtime.Poller, {:latest, count})
  end

  def die() do
    GenServer.call(Glerl.Realtime.Poller, :die)
  end
end
