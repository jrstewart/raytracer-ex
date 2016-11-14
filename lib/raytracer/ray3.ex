defmodule Raytracer.Ray3 do
  alias Raytracer.Point3
  alias Raytracer.Vector3

  defstruct [
    origin: %Point3{x: 0.0, y: 0.0, z: 0.0},
    direction: %Vector3{dx: 0.0, dy: 0.0, dz: 0.0},
  ]

  @doc """
  Computes the point at the given distance along the given ray. The given
  distance must be greater than or equal to 0 or an `ArgumentError` is raised.
  """
  def point_at(_, distance) when distance < 0 do
    raise ArgumentError, message: "negative value given for distance"
  end

  def point_at(%__MODULE__{origin: origin, direction: direction}, distance) do
    direction
    |> Vector3.multiply(distance)
    |> Vector3.add(origin)
  end
end
