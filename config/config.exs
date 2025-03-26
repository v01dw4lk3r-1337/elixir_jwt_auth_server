import Config

config :elixir_jwt_auth_server, :mongo,
  url: System.get_env("MONGO_URL") || "mongodb://localhost:27017/elixir_jwt_db"

config :elixir_jwt_auth_server,
  jwt_secret: System.get_env("JWT_SECRET") || "your-strong-secret-key"
