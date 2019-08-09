defmodule Raytracer.Model do
  @moduledoc false

  alias __MODULE__
  alias Raytracer.{Material, Parser, Shape}
  alias Raytracer.Shape.Sphere

  @enforce_keys [:material, :shape]
  defstruct [:material, :shape]

  @type t :: %Model{material: Material.t(), shape: Shape.t()}

  @behaviour Parser

  @doc """
  Parses the model data from `contents` and return a new Model struct.
  """
  @impl Parser
  def parse(contents) do
    with {:ok, type} <- Map.fetch(contents, "type"),
         {:ok, shape_module} <- shape_module_for_type(type),
         {:ok, shape_data} <- Map.fetch(contents, "data"),
         {:ok, shape} <- shape_module.parse(shape_data),
         {:ok, material_data} <- Map.fetch(contents, "material"),
         {:ok, material} <- Material.parse(material_data) do
      {:ok, %Model{shape: shape, material: material}}
    else
      {:error, msg} ->
        {:error, "error parsing model: #{msg}"}

      _ ->
        {:error, "error parsing model data"}
    end
  end

  defp shape_module_for_type("sphere"), do: {:ok, Sphere}
  defp shape_module_for_type(type), do: {:error, "module not found for shape type: #{type}"}
end
