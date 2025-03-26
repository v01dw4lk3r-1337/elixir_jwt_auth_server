# lib/elixir_jwt_auth_server/api/v1/auth/jwt_config.ex

defmodule ElixirJwtAuthServer.Api.V1.Auth.JwtConfig do
  @moduledoc """
  This module defines the configuration for JWT token generation and validation.

  ## Why is this needed?
  Joken requires a configuration module that implements `Joken.Config` to:
  - Define standard claims (like expiration).
  - Ensure consistent signing and verification logic.
  - Keep token-related logic separate from business logic.

  This modular approach keeps JWT logic centralized while allowing your signin.ex plug to focus purely on authentication.
  """

  # implements all Joken functions <- Can use JwtConfig like Joken.<function>
  use Joken.Config

  @impl true
  def token_config do
    # Expiration in seconds
    # default_claims(default_exp: 3600)
    default_claims(default_exp: 60)
  end

  def signer do
    Joken.Signer.create(
      "HS256",
      Application.get_env(:elixir_jwt_auth_server, :jwt_secret)
    )
  end
end
