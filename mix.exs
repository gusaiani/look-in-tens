defmodule Dez.Mixfile do
  use Mix.Project

  def project do
    [app: :dez,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
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
        :ex_csv       , :exfswatch    , :phoenix_slim , :scrivener
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
      {:phoenix, "~> 0.17.0"},
      {:phoenix_ecto, "~> 0.9"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.0"},
      {:phoenix_live_reload, "~> 1.0"},
      {:cowboy, "~> 1.0"},
      {:quantum, ">= 1.3.0"},
      {:httpoison, "~> 0.7"},
      {:ex_csv, "~> 0.1.3"},
      {:exfswatch, "~> 0.1.0"},
      {:phoenix_slim, "~> 0.4.0"},
      {:scrivener, "~> 0.11.0"}
    ]
  end
end
