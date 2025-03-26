# lib/elixir_jwt_auth_server/api/v1/auth/router.ex
defmodule ElixirJwtAuthServer.Api.V1.Auth.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "api/v1/auth/")
  end

  post("/register", to: ElixirJwtAuthServer.Api.V1.Auth.Register)
  post("/signin", to: ElixirJwtAuthServer.Api.V1.Auth.Signin)
  post("/check_status", to: ElixirJwtAuthServer.Api.V1.Auth.CheckStatus)
end
