defmodule Glerl.Archive.MixProject do
  use Mix.Project

  def project do
    [
      app: :glerl_archive,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger,
        :inets,
        :ssl,
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:glerl_core, path: "../glerl_core"},
      {:tzdata, "~> 1.1"}
    ]
  end
end
