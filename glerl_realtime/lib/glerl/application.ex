defmodule Glerl.Realtime.Application do
  use Application

  require Logger

  @impl true
  def start(type, args) do
    Logger.info("Glerl.Realtime.Application.start/2  #{inspect(type)}  #{inspect(args)}")

    # Glerl.Supervisor.start_link(foo: :bar)
    Glerl.Realtime.Supervisor.start_link(%{})
  end

  # example from stackoverflow of starting a supervisor directly in the application
  # https://stackoverflow.com/questions/43556398/can-an-elixir-otp-supervisor-just-use-supervisor-or-does-it-have-to-use-gense
  #
  # def start(_type, _args) do
  #   children = [
  #     # Start the Ecto repository
  #     MyApp.Repo,
  #     # Start the Telemetry supervisor
  #     MyAppWeb.Telemetry,
  #     # Start the PubSub system
  #     {Phoenix.PubSub, name: MyApp.PubSub},
  #     # Start the Endpoint (http/https)
  #     MyAppWeb.Endpoint,
  #     # Start a worker by calling: MyApp.Worker.start_link(arg)
  #     # {MyApp.Worker, arg}
  #     {DynamicSupervisor, strategy: :one_for_one, name: :agent_supervisor}
  #   ]

  #   # See https://hexdocs.pm/elixir/Supervisor.html
  #   # for other strategies and supported options
  #   opts = [strategy: :one_for_one, name: MyApp.Supervisor]
  #   Supervisor.start_link(children, opts)
  # end
end
