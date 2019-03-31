# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :video_api,
  ecto_repos: [VideoApi.Repo]

# Configures the endpoint
config :video_api, VideoApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HkeaNOfvcDYUKrHYipxHRhoVa7DcK/DwWPSU2sClFMoj143EFs6PZm9DzTO2SWRY",
  render_errors: [view: VideoApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: VideoApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian
config :video_api, VideoApiWeb.Guardian,
  issuer: "video_api",
  secret_key: "wnYhbR4deb7deWcKQJjMzTKmi9SEznozGD0Rddz6JfIctlLBv6cnPV/reM4/J81F"

config :video_api,
  uploads_dir: "/home/cory/Downloads/tmp/",
  transcodes_dir: "/home/cory/Downloads/tmp/transcodes"

config :porcelain, driver: Porcelain.Driver.Basic

config :scrivener_html,
  routes_helper: VideoApi.Router.Helpers,
  view_style: :bulma

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
