defmodule Raytracer.Point3 do
  alias Raytracer.Vector3

  defstruct [
    x: 0.0,
    y: 0.0,
    z: 0.0,
  ]

  @type t :: %__MODULE__{x: float, y: float, z: float}

  @spec add(t, t | Vector3.t) :: t
  def add(%__MODULE__{x: x1, y: y1, z: z1}, %__MODULE__{x: x2, y: y2, z: z2}) do
    %__MODULE__{x: x1 + x2, y: y1 + y2, z: z1 + z2}
  end

  def add(%__MODULE__{x: x, y: y, z: z}, %Vector3{dx: dx, dy: dy, dz: dz}) do
    %__MODULE__{x: x + dx, y: y + dy, z: z + dz}
  end

  @spec distance_between(t, t) :: float
  def distance_between(point1, point2) do
    point1
    |> squared_distance_between(point2)
    |> :math.sqrt
  end

  @spec squared_distance_between(t, t) :: float
  def squared_distance_between(%__MODULE__{x: x1, y: y1, z: z1}, %__MODULE__{x: x2, y: y2, z: z2}) do
    :math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2) + :math.pow(z2 - z1, 2)
  end

  @spec subtract(t, t | Vector3.t) :: t | Vector3.t
  def subtract(%__MODULE__{x: x, y: y, z: z}, %Vector3{dx: dx, dy: dy, dz: dz}) do
    %__MODULE__{x: x - dx, y: y - dy, z: z - dz}
  end

  def subtract(%__MODULE__{x: x1, y: y1, z: z1}, %__MODULE__{x: x2, y: y2, z: z2}) do
    %Vector3{dx: x1 - x2, dy: y1 - y2, dz: z1 - z2}
  end
end
