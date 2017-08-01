defmodule Raytracer.Geometry.RayDifferential do
  @moduledoc """
  Ray differentials provide two auxiliary rays in addition to a primary ray to
  allow additional information to be used in computations such as antialiasing
  and texture mapping.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Point
  alias Raytracer.Geometry.Ray
  alias Raytracer.Geometry.Vector
  alias Raytracer.Transform

  defstruct ray: %Ray{},
            x_origin: {0.0, 0.0, 0.0},
            y_origin: {0.0, 0.0, 0.0},
            x_direction: {0.0, 0.0, 0.0},
            y_direction: {0.0, 0.0, 0.0},
            has_differentials?: false

  @type t :: %RayDifferential{ray: Ray.t,
                              x_origin: Point.point3_t,
                              y_origin: Point.point3_t,
                              x_direction: Vector.vector3_t,
                              y_direction: Vector.vector3_t,
                              has_differentials?: boolean}

  @doc """
  Applies `transform` to `ray` and returns the resulting ray differential.
  """
  @spec apply_transform(t, Transform.t) :: t
  def apply_transform(ray_differential, transform) do
    ray_differential
    |> Map.put(:ray, Ray.apply_transform(ray_differential.ray, transform))
    |> Map.put(:x_origin, Point.apply_transform(ray_differential.x_origin, transform))
    |> Map.put(:y_origin, Point.apply_transform(ray_differential.y_origin, transform))
    |> Map.put(:x_direction, Vector.apply_transform(ray_differential.x_direction, transform))
    |> Map.put(:y_direction, Vector.apply_transform(ray_differential.y_direction, transform))
  end

  @doc """
  Scales the auxiliary ray information of `ray_differential` by the given
  `scalar` value.
  """
  @spec scale(t, number) :: t
  def scale(ray_differential, scalar) do
    ray_differential
    |> Map.put(:x_origin, scale_point(ray_differential.ray, ray_differential.x_origin, scalar))
    |> Map.put(:y_origin, scale_point(ray_differential.ray, ray_differential.y_origin, scalar))
    |> Map.put(:x_direction, scale_vector(ray_differential.ray, ray_differential.x_direction, scalar))
    |> Map.put(:y_direction, scale_vector(ray_differential.ray, ray_differential.y_direction, scalar))
  end

  defp scale_point(ray, point, scalar) do
    point
    |> Point.subtract(ray.origin)
    |> Vector.multiply(scalar)
    |> Vector.add(ray.origin)
  end

  defp scale_vector(ray, vector, scalar) do
    vector
    |> Vector.subtract(ray.direction)
    |> Vector.multiply(scalar)
    |> Vector.add(ray.direction)
  end
end
