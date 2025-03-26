# lib/elixir_jwt_auth_server/api/v1/auth/register.ex

defmodule ElixirJwtAuthServer.Api.V1.Auth.Register do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    {:ok, body, _conn} = read_body(conn)

    case Jason.decode(body) do
      {:ok, %{"username" => username, "password" => password}} ->
        hashed_password = Argon2.hash_pwd_salt(password)
        user_data = %{"username" => username, "password" => hashed_password}

        case Mongo.find_one(:mongo, "users", %{"username" => username}) do
          nil ->
            case Mongo.insert_one(:mongo, "users", user_data) do
              {:ok, _result} ->
                send_json_resp(conn, 201, %{success: "User registered successfully"})

              {:error, reason} ->
                send_json_resp(conn, 500, %{
                  error: "Error registering user: #{inspect(reason)}",
                  error_code: "MONGO_INS1_FAILURE"
                })
            end

          _existing_user ->
            send_json_resp(conn, 409, %{
              error: "Username already registered",
              error_code: "USER_EXISTS"
            })
        end

      {:error, reason} ->
        send_json_resp(conn, 400, %{
          error: "Invalid JSON: #{inspect(reason)}",
          error_code: "INVALID_JSON"
        })

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

  defp send_json_resp(conn, status, message) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(message))
  end
end
