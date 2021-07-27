# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :stonex,
  ecto_repos: [Stonex.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :stonex, StonexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "058KKrGl3NKgJj7KuJrmNXyN1SyKxY5BgBrATpKQxgmYTTGP2ftNQGvWg2EKQ0B3",
  render_errors: [view: StonexWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Stonex.PubSub,
  force_ssl: [rewrite_on: [:x_forwarded_proto], host: nil],
  https: [
    port: 443,
    cipher_suite: :strong,
    otp_app: :stonex,
    keyfile: Path.expand("../priv/cert/privkey1.pem", __DIR__),
    certfile: Path.expand("../priv/cert/cert1.pem", __DIR__),
    # OPTIONAL Key for intermediate certificates:
    cacertfile: Path.expand("../priv/cert/fullchain1.pem", __DIR__)
  ],
  live_view: [signing_salt: "HRYNmytw"]

config :stonex, StonexWeb.Auth.Guardian,
  issuer: "stonex",
  ttl: {30, :minutes},
  secret_key:
    System.get_env(
      "GUARDIAN_SECRET",
      "UaE9J9jqkLcBcV46r+WihLKwNea5HLz+X2eo3ij4CYBuelnEQo3eXi1QEIp4PzC2"
    )

config :stonex, StonexWeb.Auth.Pipeline,
  module: StonexWeb.Auth.Guardian,
  error_handler: StonexWeb.Auth.ErrorHandler

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
