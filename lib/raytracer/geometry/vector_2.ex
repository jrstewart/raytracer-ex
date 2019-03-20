defmodule Raytracer.Geometry.Vector2 do
  @moduledoc """
  This module provides a set of functions for working with two dimensional vectors.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Point2

  defstruct dx: 0.0, dy: 0.0

  @type t :: %Vector2{dx: float, dy: float}

  @doc """
  Return a vector with the absolute value applied to each component of `vector`.

  ## Examples

      iex> v = %Vector2{dx: -1.0, dy: -2.0}
      iex> Vector2.abs(v)
      %Vector2{dx: 1.0, dy: 2.0}

  """
  @spec abs(t) :: t
  def abs(vector), do: %Vector2{dx: Kernel.abs(vector.dx), dy: Kernel.abs(vector.dy)}

  @doc """
  Adds two vectors returning the resulting vector or adds a vector and a point returning the
  resulting point.

  ## Examples

      iex> v1 = %Vector2{dx: 1.0, dy: 2.0}
      iex> v2 = %Vector2{dx: 4.0, dy: 5.0}
      iex> Vector2.add(v1, v2)
      %Vector2{dx: 5.0, dy: 7.0}

      iex> v = %Vector2{dx: 4.0, dy: 5.0}
      iex> p = %Point2{x: 1.0, y: 2.0}
      iex> Vector2.add(v, p)
      %Point2{x: 5.0, y: 7.0}

  """
  @spec add(t, t | Point2.t()) :: t | Point2.t()
  def add(vector, vector_or_point)

  def add(vector1, %Vector2{} = vector2),
    do: %Vector2{dx: vector1.dx + vector2.dx, dy: vector1.dy + vector2.dy}

  def add(vector, %Point2{} = point), do: Point2.add(point, vector)

  @doc """
  Divides each of the components of `vector` by `scalar` and returns the resulting vector.

  ## Examples

      iex> v = %Vector2{dx: 2.0, dy: 4.0}
      iex> scalar = 2.0
      iex> Vector2.divide(v, scalar)
      %Vector2{dx: 1.0, dy: 2.0}

  """
  @spec divide(t, float) :: t
  def divide(vector, scalar), do: multiply(vector, 1 / scalar)

  @doc """
  Computes the dot product of two vectors.

  ## Examples

      iex> v1 = %Vector2{dx: 1.0, dy: 2.0}
      iex> v2 = %Vector2{dx: 3.0, dy: 4.0}
      iex> Vector2.dot(v1, v2)
      11.0

  """
  @spec dot(t, t) :: float
  def dot(vector1, vector2), do: vector1.dx * vector2.dx + vector1.dy * vector2.dy

  @doc """
  Computes the length of `vector`.

  ## Examples

      iex> v = %Vector2{dx: 1.0, dy: 2.0}
      iex> Vector2.length(v)
      2.23606797749979

  """
  @spec length(t) :: float
  def length(vector), do: vector |> length_squared() |> :math.sqrt()

  @doc """
  Computes the squared length of `vector`.

  ## Examples

      iex> v = %Vector2{dx: 1.0, dy: 2.0}
      iex> Vector2.length_squared(v)
      5.0

  """
  @spec length_squared(t) :: float
  def length_squared(vector), do: vector.dx * vector.dx + vector.dy * vector.dy

  @doc """
  Returns the component of `vector` with the largest value.

  ## Examples

      iex> Vector2.max_component(%Vector2{dx: 2.0, dy: 1.0})
      2.0

      iex> Vector2.max_component(%Vector2{dx: 2.0, dy: 4.0})
      4.0

  """
  @spec max_component(t) :: float
  def max_component(vector), do: max(vector.dx, vector.dy)

  @doc """
  Returns the component of `vector` with the smallest value.

  ## Examples

      iex> Vector2.min_component(%Vector2{dx: 1.0, dy: 2.0})
      1.0

      iex> Vector2.min_component(%Vector2{dx: 2.0, dy: 1.0})
      1.0

  """
  @spec min_component(t) :: float
  def min_component(vector), do: min(vector.dx, vector.dy)

  @doc """
  Multiplies each of the component of `vector` by `scalar` and returns the resulting vector.

  ## Examples

      iex> v = %Vector2{dx: 2.0, dy: 4.0}
      iex> scalar = 2.0
      iex> Vector2.multiply(v, scalar)
      %Vector2{dx: 4.0, dy: 8.0}

  """
  @spec multiply(t, float) :: t
  def multiply(vector, scalar), do: %Vector2{dx: vector.dx * scalar, dy: vector.dy * scalar}

  @doc """
  Returns the vector pointing in the opposite direction of `vector`.

  ## Examples

      iex> v = %Vector2{dx: 1.0, dy: 2.0}
      iex> Vector2.negate(v)
      %Vector2{dx: -1.0, dy: -2.0}

  """
  @spec negate(t) :: t
  def negate(vector), do: %Vector2{dx: -vector.dx, dy: -vector.dy}

  @doc """
  Normalizes `vector` and returns the resulting vector.

  ## Examples

      iex> v = %Vector2{dx: 10.0, dy: 8.0}
      iex> Vector2.normalize(v)
      %Vector2{dx: 0.7808688094430304, dy: 0.6246950475544243}

  """
  @spec normalize(t) :: t
  def normalize(vector), do: divide(vector, Vector2.length(vector))

  @doc """
  Subtracts two vectors and returns the resulting vector.

  ## Examples

      iex> v1 = %Vector2{dx: 1.0, dy: 5.0}
      iex> v2 = %Vector2{dx: 2.0, dy: 3.0}
      iex> Vector2.subtract(v1, v2)
      %Vector2{dx: -1.0, dy: 2.0}

  """
  @spec subtract(t, t) :: t
  def subtract(vector1, vector2),
    do: %Vector2{dx: vector1.dx - vector2.dx, dy: vector1.dy - vector2.dy}
end
