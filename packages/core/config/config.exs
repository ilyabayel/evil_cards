# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :core,
  ecto_repos: [Core.Repo]

# Configures the endpoint
config :core, CoreWeb.Endpoint,
  url: [host: "0.0.0.0"],
  secret_key_base: "eEM+bnw26gJQxQK3MG2NA6jDYHiXlZdvlEl2Zs7soZiBUDy6t3JVpjZLzeeUZoYY",
  render_errors: [view: CoreWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Core.PubSub,
  live_view: [signing_salt: "EVTsjPi5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
