defmodule Dez.Mixfile do
  use Mix.Project

  def project do
    [app: :dez,
     version: "0.0.1",
     elixir: "~> 1.2.2",
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
        :phoenix      , :phoenix_html , :cowboy       , :logger    ,
        :phoenix_ecto , :postgrex     , :quantum      , :httpoison ,
        :ex_csv       , :phoenix_slim , :scrivener
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
      {:phoenix, "~> 1.1.3"},
      {:phoenix_ecto, "~> 2.0"},
      {:postgrex, ">= 0.10.0"},
      {:phoenix_html, "~> 2.3.1"},
      {:cowboy, "~> 1.0.4"},
      {:quantum, ">= 1.6.1"},
      {:httpoison, "~> 0.8.1"},
      {:ex_csv, ">= 0.1.4"},
      {:phoenix_slim, ">= 0.4.0"},
      {:scrivener, ">= 1.1.0"},
      {:phoenix_live_reload, "~> 1.0.3", only: :dev},
      {:apex, "~> 0.3.6", only: :dev}
    ]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
