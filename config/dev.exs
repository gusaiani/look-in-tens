use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :dez, Dez.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: ["node_modules/.bin/webpack", "--watch", "--colors", "--progress",
    cd: Path.expand("../", __DIR__)]]

# Watch static and templates for browser reloading.
config :dez, Dez.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex|slim)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Configure your database
config :dez, Dez.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "dez_dev",
  size: 10 # The amount of database connections in the pool

config :logger, format: "[$level] $message\n",
  backends: [{LoggerFileBackend, :error_log}, :console]

config :logger, :error_log,
  path: "log/error.log",
  level: :error
