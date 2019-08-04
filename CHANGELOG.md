# Changelog

## v1.1.2
* Further improves documentation

## v1.1.1
* Improves documentation

## v1.1.0
* Implementations moved to `StructAccess` from the `__using__` macro itself.
  This should improve compilation times slightly by requiring less code to be
  added to modules that use `StructAccess`
  ([#1](https://github.com/mbramson/struct_access/pull/1))
* No longer implement `c:Access.get/2` as this was removed in Elixir `1.7.0`.
  As such `StructAccess` no longer supports Elixir versions `< 1.7.0`.

## v1.0.0
* Initial Release
