defmodule Zarex.Mixfile do
  use Mix.Project

  def project do
    [app: :zarex,
     version: "0.2.0",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    "Filename sanitization for Elixir"
  end

  defp deps do
    [{:inch_ex, only: :docs},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.7", only: :dev}]
  end

  defp package do
    [files: ["lib", "mix.exs", "README*", "LICENSE*"],
     contributors: ["Richard Nyström"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/ricn/zarex", "Docs" => "http://hexdocs.pm/zarex"}]
  end
end
