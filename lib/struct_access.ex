defmodule StructAccess do
  @moduledoc """
  Provides a standard callback implementation for the `Access` behaviour.

  Implements the following callbacks for the struct where this module is used:
  - `c:Access.fetch/2`
  - `c:Access.get_and_update/3`
  - `c:Access.pop/2`

  To define these callback and include the proper behavior all you have to do
  is add `use StructAccess` to the module defining your struct.

  Adding

  ```
  use StructAccess
  ```

  to a module is equivalent to adding the following to that module:

  ```
  @behaviour Access

  @impl Access
  def fetch(struct, key), do: StructAccess.fetch(struct, key)

  @impl Access
  def get_and_update(struct, key, fun) when is_function(fun, 1) do
    StructAccess.get_and_update(struct, key, fun)
  end

  @impl Access
  def pop(struct, key, default \\\\ nil) do
    StructAccess.pop(struct, key, default)
  end

  defoverridable Access
  ```

  This module is simply a shortcut to avoid that boilerplate.

  If any of the implementations in `StructAccess` are not sufficient, they all
  can be overridden.
  """

  @behaviour Access

  defmacro __using__(_opts) do
    quote do
      @behaviour Access

      @impl Access
      def fetch(struct, key), do: StructAccess.fetch(struct, key)

      @impl Access
      def get_and_update(struct, key, fun) when is_function(fun, 1) do
        StructAccess.get_and_update(struct, key, fun)
      end

      @impl Access
      def pop(struct, key, default \\ nil) do
        StructAccess.pop(struct, key, default)
      end

      defoverridable Access
    end
  end

  @doc """
  Retrieves the given key from the given struct.

  Implements the `c:Access.fetch/2` callback.
  """
  def fetch(struct, key), do: Map.fetch(struct, key)

  @doc """
  Retrieves the given key from the given struct with a default.
  """
  def get(struct, key, default \\ nil), do: Map.get(struct, key, default)

  @doc """
  Retrives the given key from the given struct and updates it at the same time.

  Implements the `c:Access.get_and_update/3` callback.
  """
  def get_and_update(struct, key, fun) when is_function(fun, 1) do
    current = get(struct, key)

    case fun.(current) do
      {get, update} ->
        {get, Map.put(struct, key, update)}

      :pop ->
        pop(struct, key)

      other ->
        raise "the given function must return a two-element tuple or :pop, got: #{inspect(other)}"
    end
  end

  @doc """
  Pops the given key from the given struct. As struct keys can't be deleted
  this simply sets the value of the popped key to `nil`.

  Implements the `c:Access.pop/2` callback.
  """
  def pop(struct, key, default \\ nil) do
    case fetch(struct, key) do
      {:ok, old_value} ->
        {old_value, Map.put(struct, key, nil)}

      :error ->
        {default, struct}
    end
  end
end
