defmodule Dez.Mixfile do
  use Mix.Project

  def project do
    [app: :dez,
     version: "0.0.1",
     elixir: "~> 1.3.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod: {Dez, []},
      applications: [
        :phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger,
        :phoenix_ecto, :postgrex, :quantum, :httpoison,
        :ex_csv, :phoenix_slim, :floki, :gettext
      ]
    ]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:apex, "~> 0.5.1", only: :dev},
      {:cowboy, "~> 1.0.4"},
      {:ex_csv, ">= 0.1.5"},
      {:floki, "~>0.9.0"},
      {:gettext, "~> 0.11"},
      {:httpoison, "~> 0.9.0"},
      {:phoenix_ecto, "~> 3.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0.5", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_slim, ">= 0.4.0"},
      {:phoenix, "~> 1.2.0"},
      {:postgrex, ">= 0.11.2"},
      {:quantum, ">= 1.7.1"},
    ]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
