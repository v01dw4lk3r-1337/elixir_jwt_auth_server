defmodule ElixirJwtAuthServerTest do
  use ExUnit.Case
  doctest ElixirJwtAuthServer

  test "greets the world" do
    assert ElixirJwtAuthServer.hello() == :world
  end
end
