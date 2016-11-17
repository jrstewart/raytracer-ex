defmodule Raytracer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :raytracer,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      escript: escript_config(),
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:credo, "~> 0.5.2", only: [:dev]},
    ]
  end

  defp escript_config do
    [main_module: Raytracer]
  end
end
