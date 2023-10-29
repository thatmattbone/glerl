defmodule Glerl.Realtime.Client do

  def latest() do
    GenServer.call(Glerl.Realtime.Poller, :latest)
  end

end
