import Config

config :app, App.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "app_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :app, AppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "zAVViFVJDNauYk7bvAkruxr2T3aCq/Qn66x330qbMqJnapvVrtrqoyGz04ZKLiWV",
  server: false

config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime
