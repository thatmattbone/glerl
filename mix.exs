defmodule Glerl.MixProject do
    use Mix.Project
  
    def project do
      [
        app: :glerl,
        version: "0.1.0",
        elixir: "~> 1.15",
        start_permanent: Mix.env() == :prod,
        deps: deps(),
        test_coverage: [
          summary: [threshold: 10]
        ]
      ]
    end
  
    # Run "mix help compile.app" to learn about applications.
    def application do
      [
        extra_applications: [
            :logger,
            :inets,
            :ssl,
            :observer, :wx, :runtime_tools, # need this in elixir 1.15 to get :observer.start() to work
        ],
        mod: {Glerl.Realtime.Application, []},
      ]
    end
  
    # Run "mix help deps" to learn about dependencies.
    defp deps do
      [
        {:tzdata, "~> 1.1"},
        {:bounded_map_buffer, "~> 0.1.0"},
      ]
    end
  end