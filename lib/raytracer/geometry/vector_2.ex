defmodule Raytracer.Geometry.Vector2 do
  @moduledoc """
  Two-dimensional vector represented by components (dx, dy).
  """

  alias __MODULE__
  alias Raytracer.Geometry.Point2

  defstruct [
    dx: 0.0,
    dy: 0.0,
  ]

  @type t :: %Vector2{dx: number, dy: number}

  @doc """
  Return a vector with the absolute value applied to each component of `vector`.
  """
  @spec abs(t) :: t
  def abs(vector)

  def abs(%Vector2{dx: dx, dy: dy}) do
    %Vector2{dx: Kernel.abs(dx), dy: Kernel.abs(dy)}
  end

  @doc """
  Adds two vectors returning the resulting vector, or adds a vector and a point
  returning the resulting point.
  """
  @spec add(t, t | Point2.t) :: t | Point2.t
  def add(vector, vector_or_point)

  def add(%Vector2{dx: dx1, dy: dy1}, %Vector2{dx: dx2, dy: dy2}) do
    %Vector2{dx: dx1 + dx2, dy: dy1 + dy2}
  end

  def add(%Vector2{dx: dx, dy: dy}, %Point2{x: x, y: y}) do
    %Point2{x: dx + x, y: dy + y}
  end

  @doc """
  Divides each of the components of `vector` by `scalar` and returns the
  resulting vector. An error is raised if `scalar` is equal to 0.
  """
  @spec divide(t, number) :: t
  def divide(_vector, scalar) when scalar == 0 do
    raise ArgumentError, message: "scalar value 0 results in division by 0"
  end

  def divide(vector, scalar) do
    multiply(vector, 1.0 / scalar)
  end

  @doc """
  Computes the dot product of `vector1` and `vector2`.
  """
  @spec dot(t, t) :: number
  def dot(vector1, vector2)

  def dot(%Vector2{dx: dx1, dy: dy1}, %Vector2{dx: dx2, dy: dy2}) do
    (dx1 * dx2) + (dy1 * dy2)
  end

  @doc """
  Computes the length of `vector`.
  """
  @spec length(t) :: float
  def length(vector) do
    vector |> length_squared |> :math.sqrt
  end

  @doc """
  Computes the squared length of `vector`.
  """
  @spec length_squared(t) :: number
  def length_squared(vector)

  def length_squared(%Vector2{dx: dx, dy: dy}) do
    (dx * dx) + (dy * dy)
  end

  @doc """
  Returns the component of `vector` with the largest value.
  """
  @spec max_component(t) :: number
  def max_component(vector)

  def max_component(%Vector2{dx: dx, dy: dy}) do
    max(dx, dy)
  end

  @doc """
  Returns the component of `vector` with the smallest value.
  """
  @spec min_component(t) :: number
  def min_component(vector)

  def min_component(%Vector2{dx: dx, dy: dy}) do
    min(dx, dy)
  end

  @doc """
  Multiplies each of the component of `vector` by `scalar` and returns the
  resulting vector.
  """
  @spec multiply(t, number) :: t
  def multiply(vector, scalar)

  def multiply(%Vector2{dx: dx, dy: dy}, scalar) do
    %Vector2{dx: dx * scalar, dy: dy * scalar}
  end

  @doc """
  Returns the vector pointing in the opposite direction of `vector`.
  """
  @spec negate(t) :: t
  def negate(vector)

  def negate(%Vector2{dx: dx, dy: dy}) do
    %Vector2{dx: -dx, dy: -dy}
  end

  @doc """
  Normalizes `vector` and returns the resulting vector.
  """
  @spec normalize(t) :: t
  def normalize(vector) do
    divide(vector, Vector2.length(vector))
  end

  @doc """
  Subtracts two vectors and returns the resulting vector.
  """
  @spec subtract(t, t) :: t
  def subtract(vector1, vector2)

  def subtract(%Vector2{dx: dx1, dy: dy1}, %Vector2{dx: dx2, dy: dy2}) do
    %Vector2{dx: dx1 - dx2, dy: dy1 - dy2}
  end
end
