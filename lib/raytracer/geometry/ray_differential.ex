defmodule Raytracer.Geometry.RayDifferential do
  @moduledoc """
  Ray differentials provide two auxiliary rays in addition to a primary ray to
  allow additional information to be used in computations such as
  antialiasing and texture mapping.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Ray
  alias Raytracer.Geometry.Point
  alias Raytracer.Geometry.Vector


  defstruct [
    ray: %Ray{},
    x_origin: {0.0, 0.0, 0.0},
    y_origin: {0.0, 0.0, 0.0},
    x_direction: {0.0, 0.0, 0.0},
    y_direction: {0.0, 0.0, 0.0},
    has_differentials?: false,
  ]


  @type t :: %RayDifferential{
    ray: Ray.t,
    x_origin: Point.point3_t,
    y_origin: Point.point3_t,
    x_direction: Vector.vector3_t,
    y_direction: Vector.vector3_t,
    has_differentials?: boolean,
  }


  @doc """
  Scales the auxiliary ray information of `ray_differential` by the given
  `scalar` value.
  """
  @spec scale(t, number) :: t

  def scale(
    %RayDifferential{
      ray: ray,
      x_origin: x_origin,
      y_origin: y_origin,
      x_direction: x_direction,
      y_direction: y_direction,
    } = ray_differential,
    scalar
  ) do
    ray_differential
    |> Map.put(:x_origin, scale_point(ray, x_origin, scalar))
    |> Map.put(:y_origin, scale_point(ray, y_origin, scalar))
    |> Map.put(:x_direction, scale_vector(ray, x_direction, scalar))
    |> Map.put(:y_direction, scale_vector(ray, y_direction, scalar))
  end


  defp scale_point(%Ray{origin: origin}, point, scalar) do
    point
    |> Point.subtract(origin)
    |> Vector.multiply(scalar)
    |> Vector.add(origin)
  end


  defp scale_vector(%Ray{direction: direction}, vector, scalar) do
    vector
    |> Vector.subtract(direction)
    |> Vector.multiply(scalar)
    |> Vector.add(direction)
  end
end
