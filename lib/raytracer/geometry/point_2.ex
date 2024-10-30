defmodule Raytracer.Geometry.Point2 do
  @moduledoc """
  This module provides a set of functions for working with two dimensional points.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Vector2

  defstruct x: 0.0, y: 0.0

  @type t :: %Point2{x: float, y: float}

  @doc """
  Return a point with the absolute value applied to each coordinate of `point`.

  ## Examples

      iex> p = %Point2{x: -1.0, y: -2.0}
      iex> Point2.abs(p)
      %Point2{x: 1.0, y: 2.0}

  """
  @spec abs(t) :: t
  def abs(point), do: %Point2{x: Kernel.abs(point.x), y: Kernel.abs(point.y)}

  @doc """
  Adds two points or a point and a vector and returns the resulting point.

  ## Examples

      iex> p1 = %Point2{x: 1.0, y: 2.0}
      iex> p2 = %Point2{x: 4.0, y: 5.0}
      iex> Point2.add(p1, p2)
      %Point2{x: 5.0, y: 7.0}

      iex> p = %Point2{x: 1.0, y: 2.0}
      iex> v = %Vector2{dx: 4.0, dy: 5.0}
      iex> Point2.add(p, v)
      %Point2{x: 5.0, y: 7.0}

  """
  @spec add(t, t | Vector2.t()) :: t
  def add(point, point_or_vector)
  def add(point1, %Point2{} = point2), do: %Point2{x: point1.x + point2.x, y: point1.y + point2.y}
  def add(point, %Vector2{} = vector), do: %Point2{x: point.x + vector.dx, y: point.y + vector.dy}

  @doc """
  Computes the distance between `point1` and `point2`.

  ## Examples

      iex> p1 = %Point2{x: 0.0, y: 0.0}
      iex> p2 = %Point2{x: 1.0, y: 2.0}
      iex> Point2.distance_between(p1, p2)
      2.23606797749979

  """
  @spec distance_between(t, t) :: float
  def distance_between(point1, point2), do: point1 |> subtract(point2) |> Vector2.length()

  @doc """
  Computes the squared distance between `point1` and `point2`.

  ## Examples

      iex> p1 = %Point2{x: 0.0, y: 0.0}
      iex> p2 = %Point2{x: 1.0, y: 2.0}
      iex> Point2.distance_between_squared(p1, p2)
      5.0

  """
  @spec distance_between_squared(t, t) :: float
  def distance_between_squared(point1, point2),
    do: point1 |> subtract(point2) |> Vector2.length_squared()

  @doc """
  Divides each of the coordinates of `point` by `scalar` and returns the resulting point.

  ## Examples

      iex> p = %Point2{x: 2.0, y: 4.0}
      iex> scalar = 2.0
      iex> Point2.divide(p, scalar)
      %Point2{x: 1.0, y: 2.0}

  """
  @spec divide(t, float) :: t
  def divide(point, scalar), do: multiply(point, 1.0 / scalar)

  @doc """
  Linearly interpolates between `point1` and `point2` by the value of `t`.

  `point1` is returned when `t = 0` and `point2` is returned when `t = 1`.

  ## Examples

      iex> p1 = %Point2{x: 1.0, y: 1.0}
      iex> p2 = %Point2{x: -1.0, y: -1.0}
      iex> Point2.lerp(p1, p2, 0.5)
      %Point2{x: 0.0, y: 0.0}
      iex> Point2.lerp(p1, p2, 0.0)
      %Point2{x: 1.0, y: 1.0}
      iex> Point2.lerp(p1, p2, 1.0)
      %Point2{x: -1.0, y: -1.0}

  """
  @spec lerp(t, t, float) :: t
  def lerp(point1, _, t) when t == 0.0, do: point1
  def lerp(_, point2, 1.0), do: point2
  def lerp(point1, point2, t), do: point1 |> multiply(1 - t) |> Point2.add(multiply(point2, t))

  @doc """
  Multiplies each of the coordinates of `point` by `scalar` and returns the resulting point.

  ## Examples

      iex> p = %Point2{x: 2.0, y: 4.0}
      iex> scalar = 2.0
      iex> Point2.multiply(p, scalar)
      %Point2{x: 4.0, y: 8.0}

  """
  @spec multiply(t, float) :: t
  def multiply(point, scalar), do: %Point2{x: point.x * scalar, y: point.y * scalar}

  @doc """
  Subtracts two points returning the resulting vector, or subtracts a point and a vector returning
  the resulting point.

  ## Examples

      iex> p1 = %Point2{x: 1.0, y: 2.0}
      iex> p2 = %Point2{x: 4.0, y: 5.0}
      iex> Point2.subtract(p1, p2)
      %Vector2{dx: -3.0, dy: -3.0}

      iex> p = %Point2{x: 1.0, y: 2.0}
      iex> v = %Vector2{dx: 4.0, dy: 5.0}
      iex> Point2.subtract(p, v)
      %Point2{x: -3.0, y: -3.0}

  """
  @spec subtract(t, t | Vector2.t()) :: t | Vector2.t()
  def subtract(point, point_or_vector)

  def subtract(point1, %Point2{} = point2),
    do: %Vector2{dx: point1.x - point2.x, dy: point1.y - point2.y}

  def subtract(point, %Vector2{} = vector),
    do: %Point2{x: point.x - vector.dx, y: point.y - vector.dy}
end
