defmodule Raytracer.Geometry.Point2 do
  @moduledoc """
  This module provides a set of functions for working with two dimensional
  points.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Vector2

  defstruct x: 0.0, y: 0.0

  @type t :: %Point2{x: number(), y: number()}

  @doc """
  Return a point with the absolute value applied to each coordinate of `point`.
  """
  @spec abs(t()) :: t()
  def abs(%Point2{} = point) do
    %Point2{x: Kernel.abs(point.x), y: Kernel.abs(point.y)}
  end

  @doc """
  Adds two points or a point and a vector and returns the resulting point.
  """
  @spec add(t(), t() | Vector2.t()) :: t()
  def add(point, point_or_vector)

  def add(%Point2{} = point1, %Point2{} = point2) do
    %Point2{x: point1.x + point2.x, y: point1.y + point2.y}
  end

  def add(%Point2{} = point, %Vector2{} = vector) do
    %Point2{x: point.x + vector.dx, y: point.y + vector.dy}
  end

  @doc """
  Computes the distance between `point1` and `point2`.
  """
  @spec distance_between(t(), t()) :: float()
  def distance_between(%Point2{} = point1, %Point2{} = point2) do
    point1 |> subtract(point2) |> Vector2.length()
  end

  @doc """
  Computes the squared distance between `point1` and `point2`.
  """
  @spec distance_between_squared(t(), t()) :: number()
  def distance_between_squared(%Point2{} = point1, %Point2{} = point2) do
    point1 |> subtract(point2) |> Vector2.length_squared()
  end

  @doc """
  Divides each of the coordinates of `point` by `scalar` and returns the
  resulting point.
  """
  @spec divide(t(), number()) :: t()
  def divide(%Point2{} = point, scalar) do
    multiply(point, 1.0 / scalar)
  end

  @doc """
  Linearly interpolates between `point1` and `point2` by the value of `t`.
  `point1` is returned when `t = 0` and `point2` is returned when `t = 1`.
  """
  @spec lerp(t(), t(), number()) :: t()
  def lerp(%Point2{} = point1, _, 0), do: point1

  def lerp(_, %Point2{} = point2, 1), do: point2

  def lerp(%Point2{} = point1, %Point2{} = point2, t) do
    point1 |> multiply(1 - t) |> add(multiply(point2, t))
  end

  @doc """
  Multiplies each of the coordinates of `point` by `scalar` and returns the
  resulting point.
  """
  @spec multiply(t(), number()) :: t()
  def multiply(%Point2{} = point, scalar) do
    %Point2{x: point.x * scalar, y: point.y * scalar}
  end

  @doc """
  Subtracts two points returning the resulting vector, or subtracts a point and
  a vector returning the resulting point.
  """
  @spec subtract(t(), t() | Vector2.t()) :: t() | Vector2.t()
  def subtract(point, point_or_vector)

  def subtract(%Point2{} = point1, %Point2{} = point2) do
    %Vector2{dx: point1.x - point2.x, dy: point1.y - point2.y}
  end

  def subtract(%Point2{} = point, %Vector2{} = vector) do
    %Point2{x: point.x - vector.dx, y: point.y - vector.dy}
  end
end
