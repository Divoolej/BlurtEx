# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :blurtex,
  ecto_repos: [BlurtEx.Repo]

# Configures the endpoint
config :blurtex, BlurtEx.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cT/BKUyZkI0PzN/3MNJD7yVmvFo0YHzMc8ICqoA6SAQTXphoMWs/IsuCjAZ4Za/8",
  render_errors: [view: BlurtEx.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BlurtEx.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "BlurtEx",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: "3+QFEHqo5fQer0Ma+mEMDr1HnPEhvMjINxPKauNrB527wMy38E54pTze+WCqYW7i",
  serializer: BlurtEx.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
