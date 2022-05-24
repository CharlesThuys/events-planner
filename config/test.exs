import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :planner, Planner.Repo,
  username: "root",
  password: "",
  hostname: "localhost",
  database: "planner_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :planner_web, PlannerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ChMkin+EAYBoaVJlgX45omWH9RZGVA0/7gqOUnNTgZDMX/oNlrtgXpv9zOiSG33s",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :planner, Planner.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
