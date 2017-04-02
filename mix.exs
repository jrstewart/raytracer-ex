defmodule Raytracer.Mixfile do
  use Mix.Project

  def project do
    [app: :raytracer,
     version: "0.1.0",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     escript: escript_config(),
     dialyzer: dialyzer_config()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:credo, "~> 0.7", only: [:dev]},
     {:dialyxir, "~> 0.4", only: [:dev]}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp escript_config do
    [main_module: Raytracer]
  end

  defp dialyzer_config do
    [ignore_warnings: "config/dialyzer.ignore-warnings"]
  end
end
