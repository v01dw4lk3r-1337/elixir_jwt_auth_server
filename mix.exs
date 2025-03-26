defmodule ElixirJwtAuthServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_jwt_auth_server,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ElixirJwtAuthServer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:bandit, "~> 1.6"},
      {:mongodb_driver, "~> 1.5"},
      {:jason, "~> 1.4"},
      {:argon2_elixir, "~> 4.1"},
      {:joken, "~> 2.6"}
    ]
  end
end
