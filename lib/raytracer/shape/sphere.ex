defmodule Raytracer.Shape.Sphere do
  @moduledoc """
  Three-dimensional sphere represented by a center point and radius size.
  """

  alias __MODULE__
  alias Raytracer.Geometry.{Ray, Point3, Vector3}
  alias Raytracer.Shape

  defstruct [
    center: %Point3{},
    radius: 0.0,
  ]

  @type t :: %Sphere{center: Point3.t, radius: float}

  defimpl Shape do
    def compute_intersection(
      %Sphere{center: center, radius: radius},
      %Ray{origin: origin, direction: direction}
    ) do
      origin_to_center_vector = Point3.subtract(origin, center)
      b =
        direction
        |> Vector3.multiply(2.0)
        |> Vector3.dot(origin_to_center_vector)
      c = Vector3.dot(origin_to_center_vector, origin_to_center_vector) - radius * radius

      # Use the quadratic formula with a = 1.0 to compute the
      # intesection distance.
      radical_part = b * b - 4.0 * c
      compute_intersection_distance(b, radical_part)
    end

    defp compute_intersection_distance(_b, radical_part) when radical_part < 0.0, do: nil
    defp compute_intersection_distance(b, radical_part) do
      (-b - :math.sqrt(radical_part)) / 2.0
    end

    def compute_inward_normal(%Sphere{center: center}, point) do
      center
      |> Point3.subtract(point)
      |> Vector3.normalize
    end

    def compute_outward_normal(%Sphere{center: center}, point) do
      point
      |> Point3.subtract(center)
      |> Vector3.normalize
    end
  end
end
