# lib/elixir_jwt_auth_server/api/v1/auth/check_status.ex

defmodule ElixirJwtAuthServer.Api.V1.Auth.CheckStatus do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    # IO.inspect(conn, label: "Incoming Conn")
    # IO.inspect(get_req_header(conn, "authorization"), label: "Auth header")

    case get_req_header(conn, "authorization") do
      # Will be a String.split of the authorization's corresponding element
      ["Bearer " <> token] ->
        verify_jwt(conn, token)

      _ ->
        send_json_resp(
          conn,
          401,
          %{
            error: "Missing or invalid token",
            error_code: "NO_TOKEN"
          }
        )
    end
  end

  defp verify_jwt(conn, token) do
    signer = ElixirJwtAuthServer.Api.V1.Auth.JwtConfig.signer()

    case ElixirJwtAuthServer.Api.V1.Auth.JwtConfig.verify_and_validate(token, signer) do
      {:ok, claims} ->
        send_json_resp(
          conn,
          200,
          %{
            success: "Token is valid",
            claims: claims
          }
        )

      {:error, _reason} ->
        send_json_resp(
          conn,
          401,
          %{
            error: "Invalid or expired token",
            error_code: "INVALID_TOKEN"
          }
        )
    end
  end

  defp send_json_resp(conn, status, message) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(message))
  end
end
