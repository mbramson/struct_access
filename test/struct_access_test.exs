defmodule StructAccessTest do
  use ExUnit.Case
  doctest StructAccess

  test "greets the world" do
    assert StructAccess.hello() == :world
  end
end
