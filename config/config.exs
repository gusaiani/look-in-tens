use Mix.Config

config :dez, Dez.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "a06LEcnulDei+SDInZnzIzZ2kge9w9Md8zOsX4Z7ICziEQTF1grhwsTj+8g/pyaF",
  render_errors: [default_format: "html"],
  pubsub: [name: Dez.PubSub,
           adapter: Phoenix.PubSub.PG2]
           
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :quantum, cron: [
  # "* * * * *": {Dez.CompanyController, :scrape}
]

config :phoenix, :template_engines,
    slim: PhoenixSlim.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
