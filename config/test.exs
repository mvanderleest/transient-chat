import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :transient_chat, TransientChatWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "A++efv/BTrMtzTJEApoZtzPw0UMS0p7z7mIvRavx9Dk+v3Q2lmXPX6f6aZYJSzTn",
  server: false

# In test we don't send emails.
config :transient_chat, TransientChat.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
