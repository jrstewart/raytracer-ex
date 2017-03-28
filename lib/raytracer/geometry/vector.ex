defmodule Raytracer.Geometry.Vector do
  @moduledoc """
  This module provides a set of functions for working with two and three
  dimensional vectors represented by tuples {dx, dy} and {dx, dy, dz}
  respectively.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Point
  alias Raytracer.Transform

  @type vector2_t :: {number, number}
  @type vector3_t :: {number, number, number}
  @type t :: vector2_t | vector3_t


  @doc """
  Return a vector with the absolute value applied to each component of `vector`.
  """
  @spec abs(t) :: t
  def abs(vector), do: Point.abs(vector)


  @doc """
  Adds two vectors returning the resulting vector, or adds a vector and a point
  returning the resulting point.
  """
  @spec add(t, t | Point.t) :: t | Point.t
  def add(vector, vector_or_point)
  def add(vector, vector_or_point), do: Point.add(vector, vector_or_point)


  @doc """
  Applies `transform` to `vector` and returns the resulting vector.
  """
  @spec apply_transform(vector3_t, Transform.t) :: vector3_t
  def apply_transform(vector, transform)
  def apply_transform({dx, dy, dz}, %Transform{matrix: m}) do
    {
      elem(m, 0) * dx + elem(m, 1) * dy + elem(m, 2) * dz,
      elem(m, 4) * dx + elem(m, 5) * dy + elem(m, 6) * dz,
      elem(m, 8) * dx + elem(m, 9) * dy + elem(m, 10) * dz,
    }
  end


  @doc """
  Computes the cross product of `vector1` and `vector2`.
  """
  @spec cross(vector3_t, vector3_t) :: vector3_t
  def cross(vector1, vector2)
  def cross({dx1, dy1, dz1}, {dx2, dy2, dz2}) do
    {(dy1 * dz2) - (dz1 * dy2), (dz1 * dx2) - (dx1 * dz2), (dx1 * dy2) - (dy1 * dx2)}
  end


  @doc """
  Divides each of the components of `vector` by `scalar` and returns the
  resulting vector. An error is raised if `scalar` is equal to 0.
  """
  @spec divide(t, number) :: t
  def divide(vector, scalar), do: Point.divide(vector, scalar)


  @doc """
  Computes the dot product of `vector1` and `vector2`.
  """
  @spec dot(t, t) :: number
  def dot(vector1, vector2)
  def dot({dx1, dy1}, {dx2, dy2}), do: (dx1 * dx2) + (dy1 * dy2)
  def dot({dx1, dy1, dz1}, {dx2, dy2, dz2}), do: (dx1 * dx2) + (dy1 * dy2) + (dz1 * dz2)


  @doc """
  Computes the length of `vector`.
  """
  @spec length(t) :: float
  def length(vector), do: vector |> length_squared |> :math.sqrt


  @doc """
  Computes the squared length of `vector`.
  """
  @spec length_squared(t) :: number
  def length_squared(vector)
  def length_squared({dx, dy}), do: (dx * dx) + (dy * dy)
  def length_squared({dx, dy, dz}), do: (dx * dx) + (dy * dy) + (dz * dz)


  @doc """
  Returns the component of `vector` with the largest value.
  """
  @spec max_component(t) :: number
  def max_component(vector)
  def max_component({dx, dy}), do: max(dx, dy)
  def max_component({dx, dy, dz}), do: dx |> max(dy) |> max(dz)


  @doc """
  Returns the component of `vector` with the smallest value.
  """
  @spec min_component(t) :: number
  def min_component(vector)
  def min_component({dx, dy}), do: min(dx, dy)
  def min_component({dx, dy, dz}), do: dx |> min(dy) |> min(dz)


  @doc """
  Multiplies each of the component of `vector` by `scalar` and returns the
  resulting vector.
  """
  @spec multiply(t, number) :: t
  def multiply(vector, scalar), do: Point.multiply(vector, scalar)


  @doc """
  Returns the vector pointing in the opposite direction of `vector`.
  """
  @spec negate(t) :: t
  def negate(vector)
  def negate({dx, dy}), do: {-dx, -dy}
  def negate({dx, dy, dz}), do: {-dx, -dy, -dz}


  @doc """
  Normalizes `vector` and returns the resulting vector.
  """
  @spec normalize(t) :: t
  def normalize(vector), do: divide(vector, Vector.length(vector))


  @doc """
  Subtracts two vectors and returns the resulting vector.
  """
  @spec subtract(t, t) :: t
  def subtract(vector1, vector2), do: Point.subtract(vector1, vector2)
end
