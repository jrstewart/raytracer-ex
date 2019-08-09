defmodule Raytracer.Scene do
  @moduledoc false

  alias __MODULE__
  alias Raytracer.Model
  alias Raytracer.Lighting.LightSource

  defstruct light_sources: [], models: []

  @type t :: %Scene{light_sources: list(LightSource.t()), models: list(Model.t())}

  @doc """
  Builds a scene struct from the data in the given file `path`.
  """
  @spec from_file(Path.t()) :: {:ok, t()} | {:error, File.posix()}
  def from_file(path) do
    with {:ok, data} <- File.read(path),
         {:ok, data} <- Jason.decode(data),
         {:ok, model_data} <- Map.fetch(data, "models"),
         {:ok, models} <- parse_data(Model, model_data, []),
         {:ok, light_data} <- Map.fetch(data, "lights"),
         {:ok, light_sources} <- parse_data(LightSource, light_data, []) do
      {:ok, %Scene{light_sources: light_sources, models: models}}
    else
      error ->
        error
    end
  end

  defp parse_data(_module, [], acc), do: {:ok, acc}

  defp parse_data(module, [data | rest], acc) do
    case module.parse(data) do
      {:ok, item} ->
        acc = [item | acc]
        parse_data(module, rest, acc)

      error ->
        error
    end
  end
end
