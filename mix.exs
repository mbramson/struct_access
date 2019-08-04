defmodule StructAccess.MixProject do
  use Mix.Project

  def project do
    [
      app: :struct_access,
      version: "1.1.2",
      elixir: "~> 1.7",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
      name: "StructAccess",
      source_url: "https://github.com/mbramson/struct_access"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev}
    ]
  end

  defp description() do
    """
    StructAccess provides a generic implementation of the `Access` behaviour
    for the module where this library is used.
    """
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Mathew Bramson"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mbramson/struct_access"}
    ]
  end

  defp docs do
    [main: "getting-started",
     formatter_opts: [gfm: true],
     source_url: "https://github.com/mbramson/struct_access",
     extras: [
       "docs/Getting Started.md"
    ]]
  end
end
