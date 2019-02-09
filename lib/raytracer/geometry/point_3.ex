defmodule Raytracer.Geometry.Point3 do
  @moduledoc """
  This module provides a set of functions for working with three dimensional points.
  """

  alias __MODULE__
  alias Raytracer.Transformable
  alias Raytracer.Geometry.{Matrix4x4, Vector3}

  defstruct x: 0.0, y: 0.0, z: 0.0

  @type t :: %Point3{x: float, y: float, z: float}

  @doc """
  Return a point with the absolute value applied to each coordinate of `point`.

  ## Examples

      iex> p = %Point3{x: -1.0, y: 1.0, z: -2.0}
      iex> Point3.abs(p)
      %Point3{x: 1.0, y: 1.0, z: 2.0}

  """
  @spec abs(t) :: t
  def abs(point),
    do: %Point3{x: Kernel.abs(point.x), y: Kernel.abs(point.y), z: Kernel.abs(point.z)}

  @doc """
  Adds two points or a point and a vector and returns the resulting point.

  ## Examples

      iex> p1 = %Point3{x: 1.0, y: 2.0, z: 3.0}
      iex> p2 = %Point3{x: 4.0, y: 5.0, z: 6.0}
      iex> Point3.add(p1, p2)
      %Point3{x: 5.0, y: 7.0, z: 9.0}

      iex> p = %Point3{x: 1.0, y: 2.0, z: 3.0}
      iex> v = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}
      iex> Point3.add(p, v)
      %Point3{x: 5.0, y: 7.0, z: 9.0}

  """
  @spec add(t, t | Vector3.t()) :: t
  def add(point, point_or_vector)

  def add(point1, %Point3{} = point2),
    do: %Point3{x: point1.x + point2.x, y: point1.y + point2.y, z: point1.z + point2.z}

  def add(point, %Vector3{} = vector),
    do: %Point3{x: point.x + vector.dx, y: point.y + vector.dy, z: point.z + vector.dz}

  @doc """
  Computes the distance between `point1` and `point2`.

  ## Examples

      iex> p1 = %Point3{x: 0.0, y: 0.0, z: 0.0}
      iex> p2 = %Point3{x: 1.0, y: 2.0, z: 3.0}
      iex> Point3.distance_between(p1, p2)
      3.7416573867739413

  """
  @spec distance_between(t, t) :: float
  def distance_between(point1, point2), do: point1 |> subtract(point2) |> Vector3.length()

  @doc """
  Computes the squared distance between `point1` and `point2`.

  ## Examples

      iex> p1 = %Point3{x: 0.0, y: 0.0, z: 0.0}
      iex> p2 = %Point3{x: 1.0, y: 2.0, z: 3.0}
      iex> Point3.distance_between_squared(p1, p2)
      14.0

  """
  @spec distance_between_squared(t, t) :: float
  def distance_between_squared(point1, point2),
    do: point1 |> subtract(point2) |> Vector3.length_squared()

  @doc """
  Divides each of the coordinates of `point` by `scalar` and returns the resulting point.

  ## Examples

      iex> p = %Point3{x: 2.0, y: 4.0, z: 6.0}
      iex> Point3.divide(p, 2.0)
      %Point3{x: 1.0, y: 2.0, z: 3.0}

  """
  @spec divide(t, float) :: t
  def divide(point, scalar), do: multiply(point, 1 / scalar)

  @doc """
  Linearly interpolates between `point1` and `point2` by the value of `t`. `point1` is returned when
  `t = 0` and `point2` is returned when `t = 1`.

  ## Examples

      iex> p1 = %Point3{x: 1.0, y: 1.0, z: 1.0}
      iex> p2 = %Point3{x: -1.0, y: -1.0, z: -1.0}
      iex> Point3.lerp(p1, p2, 0.5)
      %Point3{x: 0.0, y: 0.0, z: 0.0}
      iex> Point3.lerp(p1, p2, 0.0)
      %Point3{x: 1.0, y: 1.0, z: 1.0}
      iex> Point3.lerp(p1, p2, 1.0)
      %Point3{x: -1.0, y: -1.0, z: -1.0}

  """
  @spec lerp(t, t, float) :: t
  def lerp(point1, point2, t), do: point1 |> multiply(1.0 - t) |> add(multiply(point2, t))

  @doc """
  Multiplies each of the coordinates of `point` by `scalar` and returns the resulting point.

  ## Examples

      iex> p = %Point3{x: 2.0, y: 4.0, z: 6.0}
      iex> Point3.multiply(p, 2.0)
      %Point3{x: 4.0, y: 8.0, z: 12.0}

  """
  @spec multiply(t, float) :: t
  def multiply(point, scalar),
    do: %Point3{x: point.x * scalar, y: point.y * scalar, z: point.z * scalar}

  @doc """
  Subtracts two points returning the resulting vector or subtracts a point and a vector returning
  the resulting point.

  ## Examples

      iex> p1 = %Point3{x: 1.0, y: 2.0, z: 3.0}
      iex> p2 = %Point3{x: 4.0, y: 5.0, z: 6.0}
      iex> Point3.subtract(p1, p2)
      %Vector3{dx: -3.0, dy: -3.0, dz: -3.0}

      iex> p = %Point3{x: 1.0, y: 2.0, z: 3.0}
      iex> v = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}
      iex> Point3.subtract(p, v)
      %Point3{x: -3.0, y: -3.0, z: -3.0}

  """
  @spec subtract(t, t | Vector3.t()) :: t | Vector3.t()
  def subtract(point, point_or_vector)

  def subtract(point1, %Point3{} = point2),
    do: %Vector3{dx: point1.x - point2.x, dy: point1.y - point2.y, dz: point1.z - point2.z}

  def subtract(point, %Vector3{} = vector),
    do: %Point3{x: point.x - vector.dx, y: point.y - vector.dy, z: point.z - vector.dz}

  defimpl Transformable do
    def apply_transform(point, transform) do
      x =
        Matrix4x4.elem(transform.matrix, 0, 0) * point.x +
          Matrix4x4.elem(transform.matrix, 0, 1) * point.y +
          Matrix4x4.elem(transform.matrix, 0, 2) * point.z +
          Matrix4x4.elem(transform.matrix, 0, 3)

      y =
        Matrix4x4.elem(transform.matrix, 1, 0) * point.x +
          Matrix4x4.elem(transform.matrix, 1, 1) * point.y +
          Matrix4x4.elem(transform.matrix, 1, 2) * point.z +
          Matrix4x4.elem(transform.matrix, 1, 3)

      z =
        Matrix4x4.elem(transform.matrix, 2, 0) * point.x +
          Matrix4x4.elem(transform.matrix, 2, 1) * point.y +
          Matrix4x4.elem(transform.matrix, 2, 2) * point.z +
          Matrix4x4.elem(transform.matrix, 2, 3)

      w =
        Matrix4x4.elem(transform.matrix, 3, 0) * point.x +
          Matrix4x4.elem(transform.matrix, 3, 1) * point.y +
          Matrix4x4.elem(transform.matrix, 3, 2) * point.z +
          Matrix4x4.elem(transform.matrix, 3, 3)

      convert_to_nonhomogeneous(%Point3{x: x, y: y, z: z}, w)
    end

    defp convert_to_nonhomogeneous(point, w) when w == 1.0, do: point
    defp convert_to_nonhomogeneous(point, w), do: Point3.divide(point, w)
  end
end
