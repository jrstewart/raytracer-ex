defmodule Raytracer.Lighting.LightSource do
  @moduledoc false

  alias __MODULE__
  alias Raytracer.{ColorRGB, Parser}
  alias Raytracer.Lighting.{DirectionalLight, Light, PositionalLight}

  @enforce_keys [:color, :light]
  defstruct [:color, :light]

  @type t :: %LightSource{color: ColorRGB.t(), light: Light.t()}

  @behaviour Parser

  @doc """
  Parses the light data from `contents` and return an appropriate light struct for the type of the
  data.
  """
  @impl Parser
  def parse(contents) do
    with {:ok, type} <- Map.fetch(contents, "type"),
         {:ok, light_module} <- light_module_for_type(type),
         {:ok, light_data} <- Map.fetch(contents, "data"),
         {:ok, light} <- light_module.parse(light_data),
         {:ok, [r, g, b]} <- Map.fetch(contents, "color") do
      {:ok, %LightSource{color: %ColorRGB{red: r, green: g, blue: b}, light: light}}
    else
      {:error, msg} ->
        {:error, "error parsing light source: #{msg}"}

      _ ->
        {:error, "error parsing light source data"}
    end
  end

  defp light_module_for_type("directional"), do: {:ok, DirectionalLight}
  defp light_module_for_type("positional"), do: {:ok, PositionalLight}
  defp light_module_for_type(type), do: {:error, "module not found for light type: #{type}"}
end
