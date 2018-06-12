# Getting Started

## Description

StructAccess provides a generic implementation of the `Access` behaviour for
the module where this library is used.

## Installation

The package can be installed by adding `struct_access` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:struct_access, "~> 1.0.0"}
  ]
end
```

## Why?

Why might you want to do this? So that you can take advantage of standard
elixir access functions including the very useful `Kernal.get_in/2` and
`Kernel.put_in/2` functions with nested structs.

## How does it work?

When working with nested maps, the `Kernel.get_in/2` function can be used to
easily and safely query these maps like so:

```
iex> map = %{
             animals_sounds:
               %{
                 cat: "meow",
                 dog: "woof"
               }
           }

iex> get_in(map, [:animal_sounds, :dog]
"woof"
```

If you try the same thing with these maps defined as structs you will see an
error.

```
iex> defmodule AnimalSounds do
...>   defstruct cat: "meow", dog: "woof"
...> end

iex> defmodule Things do
...>   defstruct animal_sounds: %AnimalSounds{}
...> end

iex> things = %Things{}
%Things{animal_sounds: %AnimalSounds{cat: "meow", dog: "woof"}}

iex> get_in(things, [:animal_sounds, :cat])
** (UndefinedFunctionError) function AnimalSounds.fetch/2 is undefined (AnimalSounds does not implement the Access behaviour)
    AnimalSounds.fetch(%AnimalSounds{cat: "meow", dog: "woof"}, :animal_sounds)
    (elixir) lib/access.ex:308: Access.get/3
    (elixir) lib/kernel.ex:2036: Kernel.get_in/2
```

The solution to this is fairly straightforward, you need to add `@behaviour
Access` to your module and then implement all of the `Access` callbacks. It
might take you a bit to figure out, but it's straightforward to implement these
callbacks so that your structs behave just like maps (with a caveat or two).

But what if you have a bunch of structs in your projects that you'd like to
behave in this way? You'll end up repeating this implementation in each of your
structs. You might even decide that you should extract that to a macro so that
you can conveniently just `use` that macro in each of your structs removing the
repitition.

That's exactly what `StructAccess` does.

Here's how to use it to make the above example just work:

```
iex> defmodule AnimalSounds do
...>   use StructAccess
...>   defstruct cat: "meow", dog: "woof"
...> end

iex> defmodule Things do
...>   use StructAccess
...>   defstruct animal_sounds: %AnimalSounds{}
...> end

iex> things = %Things{}
%Things{animal_sounds: %AnimalSounds{cat: "meow", dog: "woof"}}

iex> get_in(things, [:animal_sounds, :cat])
"meow"
```

To define these callback and include the proper behavior all you have to do
is add `use StructAccess` to the module defining your struct.

Adding

```
use StructAccess
```

to a module is equivalent to adding the following to that module:

```
@behaviour Access

def fetch(struct, key), do: Map.fetch(struct, key)
def get(struct, key, default \\ nil), do: Map.get(struct, key, default)

def get_and_update(struct, key, fun) when is_function(fun, 1) do
  current = get(struct, key)

  case fun.(current) do
    {get, update} ->
      {get, Map.put(struct, key, update)}

    :pop ->
      pop(struct, key)

    other ->
      raise "the given function must return a two-element tuple or :pop, got: #\{inspect(other)}"
  end
end

def pop(struct, key, default \\ nil) do
  case fetch(struct, key) do
    {:ok, old_value} ->
      {old_value, Map.put(struct, key, nil)}

    :error ->
      {default, struct}
  end
end
```

This module is simply a shortcut to avoid that boilerplate.
