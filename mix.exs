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
      dialyzer: dialyzer_settings(),
      escript: escript_config(),
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:credo, "~> 0.5.2", only: [:dev]},
      {:dialyxir, "~> 0.4", only: [:dev]},
    ]
  end

  defp dialyzer_settings do
    [plt_add_deps: true]
  end

  defp escript_config do
    [main_module: Raytracer]
  end
end
