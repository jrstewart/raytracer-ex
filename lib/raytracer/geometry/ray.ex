defmodule Raytracer.Geometry.Ray do
  @moduledoc """
  This module provides a set of functions for working with three-dimensional
  rays represented by an origin point and a direction vector.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Point
  alias Raytracer.Geometry.Vector
  alias Raytracer.Transform

  defstruct origin: {0.0, 0.0, 0.0},
            direction: {0.0, 0.0, 0.0}

  @type t :: %Ray{origin: Point.point3_t, direction: Vector.vector3_t}

  @doc """
  Applies `transform` to `ray` and returns the resulting ray.
  """
  @spec apply_transform(t, Transform.t) :: t
  def apply_transform(ray, transform) do
    %Ray{origin: Point.apply_transform(ray.origin, transform),
         direction: Vector.apply_transform(ray.direction, transform)}
  end

  @doc """
  Computes the point at `distance` on `ray` returning a tuple `{:ok, point}`
  where `point` is the computed point. `{:error, :none}` is returned if
  `distance` is less than 0.
  """
  @spec point_at(t, number) :: {atom, Point.point3_t | atom}
  def point_at(_, distance) when distance < 0, do: {:error, :none}
  def point_at(ray, distance) do
    {:ok, ray.direction |> Vector.multiply(distance) |> Vector.add(ray.origin)}
  end
end
