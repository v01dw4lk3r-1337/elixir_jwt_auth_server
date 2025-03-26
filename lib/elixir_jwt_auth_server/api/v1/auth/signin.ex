# lib/elixir_jwt_auth_server/api/v1/auth/signin.ex

defmodule ElixirJwtAuthServer.Api.V1.Auth.Signin do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    {:ok, body, _conn} = read_body(conn)

    case Jason.decode(body) do
      {:ok, %{"username" => username, "password" => password}} ->
        authenticate_user(conn, username, password)

      {:error, reason} ->
        send_json_resp(
          conn,
          400,
          %{
            error: "Invalid JSON: #{inspect(reason)}",
            error_code: "INVALID_JSON"
          }
        )

      _ ->
        send_json_resp(
          conn,
          400,
          %{
            error: "Invalid or missing fields",
            error_code: "MISSING_FIELDS"
          }
        )
    end
  end

  defp authenticate_user(conn, username, password) do
    case Mongo.find_one(:mongo, "users", %{"username" => username}) do
      nil ->
        send_json_resp(conn, 401, %{
          error: "User doesn't exist!",
          error_code: "NONEXISTENT_USER"
        })

      # De-structure the user map to get only the password field
      %{"password" => hashed_password} = user ->
        if Argon2.verify_pass(password, hashed_password) do
          token = generate_jwt(user["username"])

          send_json_resp(
            conn,
            200,
            %{
              success: "User authenticated successfully!",
              token: token
            }
          )
        else
          send_json_resp(
            conn,
            401,
            %{
              error: "Invalid credentials",
              error_code: "PASS_MISMATCH"
            }
          )
        end
    end
  end

  defp generate_jwt(username) do
    signer = ElixirJwtAuthServer.Api.V1.Auth.JwtConfig.signer()

    # No need to manually set "exp" (handled in JwtConfig)
    # iat (issued at) <- for debugging token creation times
    claims = %{"sub" => username, "iat" => Joken.current_time()}
    {:ok, token, _} = ElixirJwtAuthServer.Api.V1.Auth.JwtConfig.generate_and_sign(claims, signer)
    token
  end

  defp send_json_resp(conn, status, message) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(message))
  end
end
