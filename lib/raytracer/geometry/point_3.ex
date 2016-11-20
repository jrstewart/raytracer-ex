defmodule Raytracer.Geometry.Point3 do
  @moduledoc """
  Three-dimensional point represented by coordinates (x, y, z).
  """

  alias __MODULE__
  alias Raytracer.Geometry.Vector3

  defstruct [
    x: 0.0,
    y: 0.0,
    z: 0.0,
  ]

  @type t :: %Point3{x: number, y: number, z: number}

  @doc """
  Return a point with the absolute value applied to each coordinate of `point`.
  """
  @spec abs(t) :: t
  def abs(point)

  def abs(%Point3{x: x, y: y, z: z}) do
    %Point3{x: Kernel.abs(x), y: Kernel.abs(y), z: Kernel.abs(z)}
  end

  @doc """
  Adds two points or a point and a vector and returns the resulting point.
  """
  @spec add(t, t | Vector3.t) :: t
  def add(point, point_or_vector)

  def add(%Point3{x: x1, y: y1, z: z1}, %Point3{x: x2, y: y2, z: z2}) do
    %Point3{x: x1 + x2, y: y1 + y2, z: z1 + z2}
  end

  def add(%Point3{x: x, y: y, z: z}, %Vector3{dx: dx, dy: dy, dz: dz}) do
    %Point3{x: x + dx, y: y + dy, z: z + dz}
  end

  @doc """
  Computes the distance between `point1` and `point2`.
  """
  @spec distance_between(t, t) :: float
  def distance_between(point1, point2) do
    point1 |> subtract(point2) |> Vector3.length
  end

  @doc """
  Computes the squared distance between `point1` and `point2`.
  """
  @spec distance_between_squared(t, t) :: float
  def distance_between_squared(point1, point2) do
    point1 |> subtract(point2) |> Vector3.length_squared
  end

  @doc """
  Divides each of the coordinates of `point` by `scalar` and returns the
  resulting point. An error is raised if `scalar` is equal to 0.
  """
  @spec divide(t, number) :: t
  def divide(_point, scalar) when scalar == 0.0 do
    raise ArgumentError, message: "scalar value 0 results in division by 0"
  end

  def divide(point, scalar) do
    multiply(point, 1.0 / scalar)
  end

  @doc """
  Linearly interpolates between `point1` and `point2` by the value of `t`.
  `point1` is returned when `t = 0` and `point2` is returned when `t = 1`.
  """
  @spec lerp(t, t, number) :: t
  def lerp(point1, _point2, 0), do: point1

  def lerp(_point1, point2, 1), do: point2

  def lerp(point1, point2, t) do
    point1
    |> multiply(1 - t)
    |> add(multiply(point2, t))
  end

  @doc """
  Multiplies each of the coordinates of `point` by `scalar` and returns the
  resulting point.
  """
  @spec multiply(t, float) :: t
  def multiply(%Point3{x: x, y: y, z: z}, scalar) do
    %Point3{x: x * scalar, y: y * scalar, z: z * scalar}
  end

  @doc """
  Subtracts two points returning the resulting vector, or subtracts a point and a
  vector and returning the resulting point.
  """
  @spec subtract(t, t | Vector3.t) :: t | Vector3.t
  def subtract(point, point_or_vector)

  def subtract(%Point3{x: x1, y: y1, z: z1}, %Point3{x: x2, y: y2, z: z2}) do
    %Vector3{dx: x1 - x2, dy: y1 - y2, dz: z1 - z2}
  end

  def subtract(%Point3{x: x, y: y, z: z}, %Vector3{dx: dx, dy: dy, dz: dz}) do
    %Point3{x: x - dx, y: y - dy, z: z - dz}
  end
end
