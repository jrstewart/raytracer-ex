defmodule Raytracer.Geometry.Point3 do
  alias Raytracer.Geometry.Vector3

  defstruct [
    x: 0.0,
    y: 0.0,
    z: 0.0,
  ]

  @type t :: %__MODULE__{x: float, y: float, z: float}

  @spec abs(t) :: t
  def abs(%__MODULE__{x: x, y: y, z: z}) do
    %__MODULE__{x: Kernel.abs(x), y: Kernel.abs(y), z: Kernel.abs(z)}
  end

  @spec add(t, t | Vector3.t) :: t
  def add(%__MODULE__{x: x1, y: y1, z: z1}, %__MODULE__{x: x2, y: y2, z: z2}) do
    %__MODULE__{x: x1 + x2, y: y1 + y2, z: z1 + z2}
  end

  def add(%__MODULE__{x: x, y: y, z: z}, %Vector3{dx: dx, dy: dy, dz: dz}) do
    %__MODULE__{x: x + dx, y: y + dy, z: z + dz}
  end

  @spec distance_between(t, t) :: float
  def distance_between(point1, point2) do
    point1 |> subtract(point2) |> Vector3.length
  end

  @spec distance_between_squared(t, t) :: float
  def distance_between_squared(point1, point2) do
    point1 |> subtract(point2) |> Vector3.length_squared
  end

  @spec divide(t, float) :: t
  def divide(_point, scalar) when scalar == 0.0 do
    raise ArgumentError, message: "scalar value 0 results in division by 0"
  end

  def divide(point, scalar) do
    multiply(point, 1.0 / scalar)
  end

  @spec lerp(float, t, t) :: t
  def lerp(t, point1, point2) do
    point1
    |> multiply(1 - t)
    |> add(multiply(point2, t))
  end

  @spec multiply(t, float) :: t
  def multiply(%__MODULE__{x: x, y: y, z: z}, scalar) do
    %__MODULE__{x: x * scalar, y: y * scalar, z: z * scalar}
  end

  @spec subtract(t, t | Vector3.t) :: t | Vector3.t
  def subtract(%__MODULE__{x: x, y: y, z: z}, %Vector3{dx: dx, dy: dy, dz: dz}) do
    %__MODULE__{x: x - dx, y: y - dy, z: z - dz}
  end

  def subtract(%__MODULE__{x: x1, y: y1, z: z1}, %__MODULE__{x: x2, y: y2, z: z2}) do
    %Vector3{dx: x1 - x2, dy: y1 - y2, dz: z1 - z2}
  end
end
