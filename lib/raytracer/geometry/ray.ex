defmodule Raytracer.Geometry.Ray do
  @moduledoc """
  Three-dimensional ray represented by an origin point and a direction vector.
  """

  alias __MODULE__
  alias Raytracer.Geometry.{Point3, Vector3}

  defstruct [
    origin: %Point3{},
    direction: %Vector3{},
  ]

  @type t :: %Ray{origin: Point3.t, direction: Vector3.t}

  @doc """
  Computes the point at `distance` on `ray`. An error is raised if `distance` is
  less than 0.
  """
  @spec point_at(t, number) :: Point3.t
  def point_at(_ray, distance) when distance < 0 do
    raise ArgumentError, message: "negative value given for distance"
  end

  def point_at(%Ray{origin: origin, direction: direction}, distance) do
    direction
    |> Vector3.multiply(distance)
    |> Vector3.add(origin)
  end
end
