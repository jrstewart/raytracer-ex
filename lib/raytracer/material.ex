defmodule Raytracer.Material do
  @moduledoc """
  This module defines a struct for representing the material properties of a model and functions for
  working with materials.
  """

  alias __MODULE__
  alias Raytracer.Parser

  defstruct diffuse: 0.0,
            normal_reflectances: [],
            reflected_scale_factor: 0.0,
            shininess: 0.0,
            specular: 0.0,
            transmitted_scale_factor: 0.0

  @type t :: %Material{
          diffuse: float(),
          normal_reflectances: list(float()),
          reflected_scale_factor: float(),
          shininess: float(),
          specular: float(),
          transmitted_scale_factor: float()
        }

  @behaviour Parser

  @doc """
  Computes the index of refraction for `material` based on the normal reflectance values of the
  material.
  """
  @spec index_of_refraction(t()) :: float()
  def index_of_refraction(%Material{normal_reflectances: []}), do: 0.0

  def index_of_refraction(material) do
    sum =
      Enum.reduce(material.normal_reflectances, 0.0, fn r, acc ->
        acc + (1 + :math.sqrt(r)) / (1 - :math.sqrt(r))
      end)

    sum / length(material.normal_reflectances)
  end

  @doc """
  Parses the model data from `contents` and return a new Model struct.
  """
  @impl Parser
  def parse(contents) do
    with {:ok, diffuse} <- Map.fetch(contents, "diffuse"),
         {:ok, specular} <- Map.fetch(contents, "specular"),
         {:ok, shininess} <- Map.fetch(contents, "shininess"),
         {:ok, reflected_scale_factor} <- Map.fetch(contents, "reflected_scale_factor"),
         {:ok, transmitted_scale_factor} <- Map.fetch(contents, "transmitted_scale_factor"),
         {:ok, normal_reflectances} <- Map.fetch(contents, "normal_reflectances") do
      {:ok,
       %Material{
         diffuse: diffuse,
         specular: specular,
         shininess: shininess,
         reflected_scale_factor: reflected_scale_factor,
         transmitted_scale_factor: transmitted_scale_factor,
         normal_reflectances: normal_reflectances
       }}
    else
      :error ->
        {:error, "error parsing material"}
    end
  end
end
