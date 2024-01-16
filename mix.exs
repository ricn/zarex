defmodule Zarex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :zarex,
      version: "1.0.5",
      elixir: "~> 1.6",
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    "Filename sanitization for Elixir"
  end

  defp deps do
    [
      {:inch_ex, "2.0.0", only: :docs},
      {:earmark, "1.4.46", only: :dev},
      {:ex_doc, "0.31.1", only: :dev},
      {:dialyxir, "1.4.3", only: [:dev], runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      contributors: ["Richard Nyström"],
      maintainers: ["Richard Nyström"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ricn/zarex", "Docs" => "http://hexdocs.pm/zarex"}
    ]
  end

  defp docs do
    [extras: ["README.md"], main: "readme"]
  end
end
