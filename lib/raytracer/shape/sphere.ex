defmodule Raytracer.Shape.Sphere do
  @moduledoc """
  Three-dimensional sphere represented by a center point and radius size.
  """

  alias __MODULE__
  alias Raytracer.Geometry.{Point3, Vector3}
  alias Raytracer.{Parser, Shape}

  defstruct center: %Point3{}, radius: 0.0

  @type t :: %Sphere{center: Point3.t(), radius: float()}

  @behaviour Parser

  @doc """
  Parses the sphere data from `contents` and return a new Sphere struct.
  """
  @impl Parser
  def parse(contents) do
    with {:ok, [x, y, z]} <- Map.fetch(contents, "center"),
         {:ok, radius} <- Map.fetch(contents, "radius") do
      {:ok, %Sphere{center: %Point3{x: x, y: y, z: z}, radius: radius}}
    else
      :error ->
        {:error, "error parsing sphere"}
    end
  end

  defimpl Shape do
    def compute_intersection(sphere, ray) do
      origin_to_center = Point3.subtract(ray.origin, sphere.center)
      b = ray.direction |> Vector3.multiply(2.0) |> Vector3.dot(origin_to_center)
      c = Vector3.dot(origin_to_center, origin_to_center) - :math.pow(sphere.radius, 2)

      # Use the quadratic formula with a = 1.0 to compute the intesection distance.
      compute_intersection_distance(b, b * b - 4.0 * c)
    end

    defp compute_intersection_distance(_, radical_part) when radical_part < 0.0, do: nil
    defp compute_intersection_distance(b, radical_part), do: (-b - :math.sqrt(radical_part)) / 2.0

    def compute_inward_normal(sphere, point),
      do: sphere.center |> Point3.subtract(point) |> Vector3.normalize()

    def compute_outward_normal(sphere, point),
      do: point |> Point3.subtract(sphere.center) |> Vector3.normalize()
  end
end
