import Config

config :app, App.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "app_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :app, AppWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "EsWr7DcJ5L+4/DCGxOe6A6joYS9AyDhwfbmW87YFaFNx0HxctsZI7KCEAFehEYdc",
  watchers: []

config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
