defmodule Raytracer.Geometry.Ray do
  @moduledoc """
  Three-dimensional ray represented by an origin point and a direction vector.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Point
  alias Raytracer.Geometry.Vector
  alias Raytracer.Transform

  defstruct [
    origin: {0.0, 0.0, 0.0},
    direction: {0.0, 0.0, 0.0},
  ]

  @type t :: %Ray{origin: Point.point3_t, direction: Vector.vector3_t}


  @doc """
  Applies `transform` to `ray` and returns the resulting ray.
  """
  @spec apply_transform(t, Transform.t) :: t
  def apply_transform(ray, transfrom)
  def apply_transform(%Ray{origin: origin, direction: direction}, transform) do
    %Ray{
      origin: Point.apply_transform(origin, transform),
      direction: Vector.apply_transform(direction, transform),
    }
  end


  @doc """
  Computes the point at `distance` on `ray`. An error is raised if `distance` is
  less than 0.
  """
  @spec point_at(t, number) :: Point.point3_t
  def point_at(_ray, distance) when distance < 0 do
    raise ArgumentError, message: "negative value given for distance"
  end

  def point_at(%Ray{origin: origin, direction: direction}, distance) do
    direction
    |> Vector.multiply(distance)
    |> Vector.add(origin)
  end
end
