defmodule Raytracer.Material do
  @moduledoc """
  This module defines a struct for representing the material properties of a model and functions for
  working with materials.
  """

  alias __MODULE__
  alias Raytracer.Parser

  @enforce_keys [
    :diffuse,
    :normal_reflectances,
    :reflected_scale_factor,
    :shininess,
    :specular,
    :transmitted_scale_factor
  ]
  defstruct [
    :diffuse,
    :normal_reflectances,
    :reflected_scale_factor,
    :shininess,
    :specular,
    :transmitted_scale_factor
  ]

  @type t :: %Material{
          diffuse: float(),
          normal_reflectances: %{red: [float(), ...], green: [float(), ...], blue: [float(), ...]},
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
  def index_of_refraction(material) do
    count = normal_reflectance_count(material)
    red_sum = sum_normal_reflectances(material.normal_reflectances.red)
    green_sum = sum_normal_reflectances(material.normal_reflectances.green)
    blue_sum = sum_normal_reflectances(material.normal_reflectances.blue)
    (red_sum + green_sum + blue_sum) / count
  end

  defp sum_normal_reflectances(normal_reflectances) do
    Enum.reduce(normal_reflectances, 0.0, fn nr, acc ->
      acc + (1.0 + :math.sqrt(nr)) / (1.0 - :math.sqrt(nr))
    end)
  end

  @doc """
  Returns the total number of normal reflectance values stored for `material`.
  """
  @spec normal_reflectance_count(t()) :: integer()
  def normal_reflectance_count(material) do
    length(material.normal_reflectances.red) +
      length(material.normal_reflectances.green) +
      length(material.normal_reflectances.blue)
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
      count = length(normal_reflectances)
      red_count = (count / 3) |> Float.ceil() |> trunc()
      blue_count = (count / 3) |> Float.floor() |> trunc()
      green_count = count - red_count - blue_count

      {:ok,
       %Material{
         diffuse: diffuse,
         specular: specular,
         shininess: shininess,
         reflected_scale_factor: reflected_scale_factor,
         transmitted_scale_factor: transmitted_scale_factor,
         normal_reflectances: %{
           red: Enum.slice(normal_reflectances, 0, red_count),
           green: Enum.slice(normal_reflectances, red_count, green_count),
           blue: Enum.slice(normal_reflectances, red_count + green_count, blue_count)
         }
       }}
    else
      :error ->
        {:error, "error parsing material"}
    end
  end
end
