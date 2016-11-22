defmodule Raytracer.Geometry.Point do
  @moduledoc """
  This module provides a set of functions for working with two and three
  dimensional points represented by tuples {x, y} and {x, y, z} respectively.
  """

  alias Raytracer.Geometry.Vector

  @type point2_t :: {number, number}
  @type point3_t :: {number, number, number}
  @type t :: point2_t | point3_t

  @doc """
  Return a point with the absolute value applied to each coordinate of `point`.
  """
  @spec abs(t) :: t
  def abs(point)
  def abs({x, y}), do: {Kernel.abs(x), Kernel.abs(y)}
  def abs({x, y, z}), do: {Kernel.abs(x), Kernel.abs(y), Kernel.abs(z)}

  @doc """
  Adds two points or a point and a vector and returns the resulting point.
  """
  @spec add(t, t) :: t
  def add(point, point_or_vector)
  def add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}
  def add({x1, y1, z1}, {x2, y2, z2}), do: {x1 + x2, y1 + y2, z1 + z2}

  @doc """
  Computes the distance between `point1` and `point2`.
  """
  @spec distance_between(t, t) :: float
  def distance_between(point1, point2) do
    point1 |> subtract(point2) |> Vector.length
  end

  @doc """
  Computes the squared distance between `point1` and `point2`.
  """
  @spec distance_between_squared(t, t) :: number
  def distance_between_squared(point1, point2) do
    point1 |> subtract(point2) |> Vector.length_squared
  end

  @doc """
  Divides each of the coordinates of `point` by `scalar` and returns the
  resulting point.
  """
  @spec divide(t, number) :: t
  def divide(point, scalar), do: multiply(point, 1.0 / scalar)

  @doc """
  Linearly interpolates between `point1` and `point2` by the value of `t`.
  `point1` is returned when `t = 0` and `point2` is returned when `t = 1`.
  """
  @spec lerp(t, t, number) :: t
  def lerp(point1, _, 0), do: point1
  def lerp(_, point2, 1), do: point2
  def lerp(point1, point2, t) do
    point1 |> multiply(1 - t) |> add(multiply(point2, t))
  end

  @doc """
  Multiplies each of the coordinates of `point` by `scalar` and returns the
  resulting point.
  """
  @spec multiply(t, number) :: t
  def multiply(point, scalar)
  def multiply({x, y}, scalar), do: {x * scalar, y * scalar}
  def multiply({x, y, z}, scalar), do: {x * scalar, y * scalar, z * scalar}

  @doc """
  Subtracts two points returning the resulting vector, or subtracts a point and a
  vector returning the resulting point.
  """
  @spec subtract(t, t | Vector.t) :: t | Vector.t
  def subtract(point, point_or_vector)
  def subtract({x1, y1}, {x2, y2}), do: {x1 - x2, y1 - y2}
  def subtract({x1, y1, z1}, {x2, y2, z2}), do: {x1 - x2, y1 - y2, z1 - z2}
end
