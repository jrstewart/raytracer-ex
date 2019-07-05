defmodule Raytracer.Shape.Sphere do
  @moduledoc """
  Three-dimensional sphere represented by a center point and radius size.
  """

  alias __MODULE__
  alias Raytracer.Geometry.{Normal3, Point3, Vector3}
  alias Raytracer.Shape

  defstruct center: %Point3{}, radius: 0.0

  @type t :: %Sphere{center: Point3.t(), radius: float}

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
      do: sphere.center |> Point3.subtract(point) |> Vector3.to_normal() |> Normal3.normalize()

    def compute_outward_normal(sphere, point),
      do: point |> Point3.subtract(sphere.center) |> Vector3.to_normal() |> Normal3.normalize()
  end
end
