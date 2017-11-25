defmodule Raytracer.Geometry.Point3 do
  @moduledoc """
  This module provides a set of functions for working with three dimensional
  points.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Matrix, as: Matrix4x4
  alias Raytracer.Geometry.Vector3
  alias Raytracer.{Transform, Transformable}

  defstruct x: 0.0, y: 0.0, z: 0.0

  @type t :: %Point3{x: number(), y: number(), z: number()}

  @doc """
  Return a point with the absolute value applied to each coordinate of `point`.
  """
  @spec abs(t()) :: t()
  def abs(%Point3{} = point) do
    %Point3{x: Kernel.abs(point.x), y: Kernel.abs(point.y), z: Kernel.abs(point.z)}
  end

  @doc """
  Adds two points or a point and a vector and returns the resulting point.
  """
  @spec add(t(), t() | Vector3.t()) :: t()
  def add(point, point_or_vector)

  def add(%Point3{} = point1, %Point3{} = point2) do
    %Point3{x: point1.x + point2.x, y: point1.y + point2.y, z: point1.z + point2.z}
  end

  def add(%Point3{} = point, %Vector3{} = vector) do
    %Point3{x: point.x + vector.dx, y: point.y + vector.dy, z: point.z + vector.dz}
  end

  @doc """
  Computes the distance between `point1` and `point2`.
  """
  @spec distance_between(t(), t()) :: float()
  def distance_between(%Point3{} = point1, %Point3{} = point2) do
    point1 |> subtract(point2) |> Vector3.length()
  end

  @doc """
  Computes the squared distance between `point1` and `point2`.
  """
  @spec distance_between_squared(t(), t()) :: number()
  def distance_between_squared(%Point3{} = point1, %Point3{} = point2) do
    point1 |> subtract(point2) |> Vector3.length_squared()
  end

  @doc """
  Divides each of the coordinates of `point` by `scalar` and returns the
  resulting point.
  """
  @spec divide(t(), number()) :: t()
  def divide(%Point3{} = point, scalar) do
    multiply(point, 1.0 / scalar)
  end

  @doc """
  Linearly interpolates between `point1` and `point2` by the value of `t`.
  `point1` is returned when `t = 0` and `point2` is returned when `t = 1`.
  """
  @spec lerp(t(), t(), number()) :: t()
  def lerp(%Point3{} = point1, _, 0), do: point1

  def lerp(_, %Point3{} = point2, 1), do: point2

  def lerp(%Point3{} = point1, %Point3{} = point2, t) do
    point1 |> multiply(1 - t) |> add(multiply(point2, t))
  end

  @doc """
  Multiplies each of the coordinates of `point` by `scalar` and returns the
  resulting point.
  """
  @spec multiply(t(), number()) :: t()
  def multiply(%Point3{} = point, scalar) do
    %Point3{x: point.x * scalar, y: point.y * scalar, z: point.z * scalar}
  end

  @doc """
  Subtracts two points returning the resulting vector, or subtracts a point and
  a vector returning the resulting point.
  """
  @spec subtract(t(), t() | Vector3.t()) :: t() | Vector3.t()
  def subtract(point, point_or_vector)

  def subtract(%Point3{} = point1, %Point3{} = point2) do
    %Vector3{dx: point1.x - point2.x, dy: point1.y - point2.y, dz: point1.z - point2.z}
  end

  def subtract(%Point3{} = point, %Vector3{} = vector) do
    %Point3{x: point.x - vector.dx, y: point.y - vector.dy, z: point.z - vector.dz}
  end

  defimpl Transformable do
    def apply_transform(%Point3{} = point, %Transform{} = transform) do
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
