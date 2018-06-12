defmodule AnimalSounds do
  use StructAccess
  defstruct cat: "meow", dog: "woof"
end

defmodule Things do
  use StructAccess
  defstruct animal_sounds: %AnimalSounds{}
end

defmodule StructAccessTest do
  use ExUnit.Case
  doctest StructAccess

  setup do
    {:ok, [sounds: %AnimalSounds{}, things: %Things{}]}
  end

  test "can use the square bracket notation on struct", %{sounds: sounds} do
    assert "meow" = sounds[:cat]
  end

  test "can use get_in on the nested structs", %{things: things} do
    assert "meow" = get_in(things, [:animal_sounds, :cat])
  end

  test "can use put_in on the nested structs", %{things: things} do
    result = put_in(things, [:animal_sounds, :cat], "moo")
    assert %Things{animal_sounds: %AnimalSounds{cat: "moo"}} = result
  end

  test "pop nils out a struct key", %{sounds: sounds} do
    assert {value, new_struct} = AnimalSounds.pop(sounds, :cat)
    assert "meow" == value
    assert %AnimalSounds{cat: nil} = new_struct
  end
end
