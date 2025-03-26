# lib/elixir_jwt_auth_sever/application.ex

defmodule ElixirJwtAuthServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @port 4000

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: ElixirJwtAuthServer.Worker.start_link(arg)
      # {ElixirJwtAuthServer.Worker, arg}
      # Starts the Bandit HTTP server
      {Bandit, scheme: :http, plug: ElixirJwtAuthServer.Api.V1.Router, port: @port},
      # Your plug should use the already established connection rather than starting a new one on every request.
      # Establishes a persistent Mongo connection
      {Mongo, url: Application.get_env(:elixir_jwt_auth_server, :mongo)[:url], name: :mongo}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirJwtAuthServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
