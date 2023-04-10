defmodule Whispex.MixProject do
  use Mix.Project

  def project do
    [
      app: :whispex,
      version: "0.1.0",
      elixir: "~> 1.14",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/vlarok/whispex"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:jason, "~> 1.2"},
      {:rambo, "~> 0.3.4"}
    ]
  end

  defp description() do
    "Elixir Whisper CLI Library"
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Vladimir Rokovanov"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/vlarok/whispex"}
    ]
  end
end
