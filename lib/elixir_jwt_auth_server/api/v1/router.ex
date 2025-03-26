# lib/elixir_jwt_auth_server/api/v1/router.ex

defmodule ElixirJwtAuthServer.Api.V1.Router do
  use Plug.Router

  # Define the pipeline (common middleware for every request)
  plug(:match)
  plug(:dispatch)

  # Define routes
  get "/" do
    send_resp(conn, 200, "Elixir JWT Auth Server - #{Mix.env()}")
  end

  forward("/api/v1/auth", to: ElixirJwtAuthServer.Api.V1.Auth.Router)
end
