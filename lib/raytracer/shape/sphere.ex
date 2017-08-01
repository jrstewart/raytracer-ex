defmodule Raytracer.Shape.Sphere do
  @moduledoc """
  Three-dimensional sphere represented by a center point and radius size.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Normal
  alias Raytracer.Geometry.Point
  alias Raytracer.Geometry.Vector
  alias Raytracer.Shape

  defstruct center: {0.0, 0.0, 0.0},
            radius: 0.0

  @type t :: %Sphere{center: Point.point3_t, radius: float}

  defimpl Shape do
    def compute_intersection(sphere, ray) do
      origin_to_center_vector = Point.subtract(ray.origin, sphere.center)
      b = ray.direction |> Vector.multiply(2.0) |> Vector.dot(origin_to_center_vector)
      c = Vector.dot(origin_to_center_vector, origin_to_center_vector) - :math.pow(sphere.radius, 2)

      # Use the quadratic formula with a = 1.0 to compute the
      # intesection distance.
      compute_intersection_distance(b, b * b - 4.0 * c)
    end

    defp compute_intersection_distance(_, radical_part) when radical_part < 0.0, do: nil
    defp compute_intersection_distance(b, radical_part), do: (-b - :math.sqrt(radical_part)) / 2.0

    def compute_inward_normal(sphere, point) do
      sphere.center |> Point.subtract(point) |> Normal.normalize
    end

    def compute_outward_normal(sphere, point) do
      point |> Point.subtract(sphere.center) |> Normal.normalize
    end
  end
end
