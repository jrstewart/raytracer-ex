defmodule Raytracer.Ray3 do
  alias Raytracer.Point3
  alias Raytracer.Vector3

  defstruct [
    origin: %Point3{x: 0.0, y: 0.0, z: 0.0},
    direction: %Vector3{dx: 0.0, dy: 0.0, dz: 0.0},
  ]

  @type t :: %__MODULE__{origin: Point3.t, direction: Vector3.t}

  @spec point_at(t, float) :: Point3.t
  def point_at(_ray, distance) when distance < 0 do
    raise ArgumentError, message: "negative value given for distance"
  end

  def point_at(%__MODULE__{origin: origin, direction: direction}, distance) do
    direction
    |> Vector3.multiply(distance)
    |> Vector3.add(origin)
  end
end
