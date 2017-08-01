defmodule Raytracer.Geometry.RayDifferential do
  @moduledoc """
  Ray differentials provide two auxiliary rays in addition to a primary ray to
  allow additional information to be used in computations such as antialiasing
  and texture mapping.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Ray
  alias Raytracer.Geometry.Point
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
  def apply_transform(ray_differential, transform)
  def apply_transform(%RayDifferential{} = rd, transform) do
    rd
    |> Map.put(:ray, Ray.apply_transform(rd.ray, transform))
    |> Map.put(:x_origin, Point.apply_transform(rd.x_origin, transform))
    |> Map.put(:y_origin, Point.apply_transform(rd.y_origin, transform))
    |> Map.put(:x_direction, Vector.apply_transform(rd.x_direction, transform))
    |> Map.put(:y_direction, Vector.apply_transform(rd.y_direction, transform))
  end

  @doc """
  Scales the auxiliary ray information of `ray_differential` by the given
  `scalar` value.
  """
  @spec scale(t, number) :: t
  def scale(ray_differential, scalar)
  def scale(%RayDifferential{} = rd, scalar) do
    rd
    |> Map.put(:x_origin, scale_point(rd.ray.origin, rd.x_origin, scalar))
    |> Map.put(:y_origin, scale_point(rd.ray.origin, rd.y_origin, scalar))
    |> Map.put(:x_direction, scale_vector(rd.ray.direction, rd.x_direction, scalar))
    |> Map.put(:y_direction, scale_vector(rd.ray.direction, rd.y_direction, scalar))
  end

  defp scale_point(ray_origin, point, scalar) do
    point
    |> Point.subtract(ray_origin)
    |> Vector.multiply(scalar)
    |> Vector.add(ray_origin)
  end

  defp scale_vector(ray_direction, vector, scalar) do
    vector
    |> Vector.subtract(ray_direction)
    |> Vector.multiply(scalar)
    |> Vector.add(ray_direction)
  end
end
