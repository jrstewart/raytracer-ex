defmodule Raytracer.Geometry.Point2 do
  @moduledoc """
  Two-dimensional point represented by coordinates (x, y).
  """

  alias __MODULE__
  alias Raytracer.Geometry.Vector2

  defstruct [
    x: 0.0,
    y: 0.0,
  ]

  @type t :: %Point2{x: number, y: number}

  @doc """
  Return a point with the absolute value applied to each coordinate of `point`.
  """
  @spec abs(t) :: t
  def abs(point)

  def abs(%Point2{x: x, y: y}) do
    %Point2{x: Kernel.abs(x), y: Kernel.abs(y)}
  end

  @doc """
  Adds two points or a point and a vector and returns the resulting point.
  """
  @spec add(t, t | Vector2.t) :: t
  def add(point, point_or_vector)

  def add(%Point2{x: x1, y: y1}, %Point2{x: x2, y: y2}) do
    %Point2{x: x1 + x2, y: y1 + y2}
  end

  def add(%Point2{x: x, y: y}, %Vector2{dx: dx, dy: dy}) do
    %Point2{x: x + dx, y: y + dy}
  end

  @doc """
  Computes the distance between `point1` and `point2`.
  """
  @spec distance_between(t, t) :: float
  def distance_between(point1, point2) do
    point1 |> subtract(point2) |> Vector2.length
  end

  @doc """
  Computes the squared distance between `point1` and `point2`.
  """
  @spec distance_between_squared(t, t) :: float
  def distance_between_squared(point1, point2) do
    point1 |> subtract(point2) |> Vector2.length_squared
  end

  @doc """
  Divides each of the coordinates of `point` by `scalar` and returns the
  resulting point. An error is raised if `scalar` is equal to 0.
  """
  @spec divide(t, number) :: t
  def divide(_point, scalar) when scalar == 0 do
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
    point1 |> multiply(1 - t) |> add(multiply(point2, t))
  end

  @doc """
  Multiplies each of the coordinates of `point` by `scalar` and returns the
  resulting point.
  """
  @spec multiply(t, number) :: t
  def multiply(point, scalar)

  def multiply(%Point2{x: x, y: y}, scalar) do
    %Point2{x: x * scalar, y: y * scalar}
  end

  @doc """
  Subtracts two points returning the resulting vector, or subtracts a point and a
  vector returning the resulting point.
  """
  @spec subtract(t, t | Vector2.t) :: t | Vector2.t
  def subtract(point, point_or_vector)

  def subtract(%Point2{x: x1, y: y1}, %Point2{x: x2, y: y2}) do
    %Vector2{dx: x1 - x2, dy: y1 - y2}
  end

  def subtract(%Point2{x: x, y: y}, %Vector2{dx: dx, dy: dy}) do
    %Point2{x: x - dx, y: y - dy}
  end
end
