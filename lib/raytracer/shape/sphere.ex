defmodule Raytracer.Shape.Sphere do
  @moduledoc """
  Three-dimensional sphere represented by a center point and radius size.
  """

  alias __MODULE__
  alias Raytracer.Geometry.{Ray, Point, Vector}
  alias Raytracer.Shape

  defstruct [
    center: {0.0, 0.0, 0.0},
    radius: 0.0,
  ]

  @type t :: %Sphere{center: Point.point3_t, radius: float}

  defimpl Shape do
    def compute_intersection(
      %Sphere{center: center, radius: radius},
      %Ray{origin: origin, direction: direction}
    ) do
      origin_to_center_vector = Point.subtract(origin, center)
      b =
        direction
        |> Vector.multiply(2.0)
        |> Vector.dot(origin_to_center_vector)
      c = Vector.dot(origin_to_center_vector, origin_to_center_vector) - radius * radius

      # Use the quadratic formula with a = 1.0 to compute the
      # intesection distance.
      radical_part = b * b - 4.0 * c
      compute_intersection_distance(b, radical_part)
    end

    defp compute_intersection_distance(_, radical_part) when radical_part < 0.0, do: nil
    defp compute_intersection_distance(b, radical_part), do: (-b - :math.sqrt(radical_part)) / 2.0

    def compute_inward_normal(%Sphere{center: center}, point) do
      center
      |> Point.subtract(point)
      |> Vector.normalize
    end

    def compute_outward_normal(%Sphere{center: center}, point) do
      point
      |> Point.subtract(center)
      |> Vector.normalize
    end
  end
end
