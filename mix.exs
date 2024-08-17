defmodule Glerl.MixProject do
    use Mix.Project

    def project do
      [
        app: :glerl,
        version: "0.2.0",
        elixir: "~> 1.17",
        start_permanent: Mix.env() == :prod,
        deps: deps(),
        test_coverage: [
          summary: [threshold: 10]
        ],
        dialyzer: [
          flags: [:unmatched_returns, :error_handling, :missing_return, :underspecs],
        ],
      ]
    end

    # Run "mix help compile.app" to learn about applications.
    def application do
      [
        extra_applications: [
            :logger,
            :inets,
            :ssl,
            :runtime_tools,

            # need these two below in elixir 1.17 to get :observer.start() to work
            :observer,
            :wx,

        ],
        mod: {Glerl.Application, []},
      ]
    end

    # Run "mix help deps" to learn about dependencies.
    defp deps do
      [
        {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
        {:tz, "~> 0.27"},
        {:jason, "~> 1.4"},
        {:bounded_map_buffer, "~> 0.1.0"},
      ]
    end
  end
