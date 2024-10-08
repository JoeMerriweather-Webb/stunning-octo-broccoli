import Config

config :app,
  ecto_repos: [App.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

config :app, AppWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: AppWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: App.PubSub,
  live_view: [signing_salt: "4T4w0HML"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :open_api_spex, :cache_adapter, OpenApiSpex.Plug.NoneCache

config :jsonapi,
  namespace: "/api"

import_config "#{config_env()}.exs"
