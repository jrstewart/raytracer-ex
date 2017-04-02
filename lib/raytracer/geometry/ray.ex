defmodule Raytracer.Geometry.Ray do
  @moduledoc """
  This module provides a set of functions for working with three-dimensional
  rays represented by a tuple consisting of an origin point and a direction
  vector {origin, direction}.
  """

  alias Raytracer.Geometry.Point
  alias Raytracer.Geometry.Vector
  alias Raytracer.Transform

  @type t :: {Point.point3_t, Vector.vector3_t}

  @doc """
  Applies `transform` to `ray` and returns the resulting ray.
  """
  @spec apply_transform(t, Transform.t) :: t
  def apply_transform(ray, transfrom)
  def apply_transform({origin, direction}, transform) do
    {Point.apply_transform(origin, transform),
     Vector.apply_transform(direction, transform)}
  end

  @doc """
  Computes the point at `distance` on `ray`. An error is raised if `distance` is
  less than 0.
  """
  @spec point_at(t, number) :: Point.point3_t
  def point_at(_ray, distance) when distance < 0 do
    raise ArgumentError, message: "negative value given for distance"
  end
  def point_at({origin, direction}, distance) do
    direction
    |> Vector.multiply(distance)
    |> Vector.add(origin)
  end
end
