use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :video_api, VideoApiWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 4000],
  url: [scheme: "https", host: System.get_env("SERVER_URL"), port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json"
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

config :video_api, VideoApi.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :video_api, VideoApiWeb.Guardian,
  issuer: "video_api",
  secret_key: Map.fetch!(System.get_env(), "SECRET_KEY")


# Finally import the config/prod.secret.exs which should be versioned
# separately.
import_config "prod.secret.exs"
