# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sampson_cookbook,
  ecto_repos: [SampsonCookbook.Repo]

# Configures the endpoint
config :sampson_cookbook, SampsonCookbookWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0GPtBx+2gaZ5XdyuXHZ4esgxbDdXQ0uoERylRSC4lLu5spP3YB/1+T1LS2uqyZxy",
  render_errors: [view: SampsonCookbookWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SampsonCookbook.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Drab
config :drab, SampsonCookbookWeb.Endpoint,
  otp_app: :sampson_cookbook

# Configures default Drab file extension
config :phoenix, :template_engines,
  drab: Drab.Live.Engine

# Configures Drab for webpack
config :drab, SampsonCookbookWeb.Endpoint,
  js_socket_constructor: "window.__socket"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
