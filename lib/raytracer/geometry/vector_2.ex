defmodule Raytracer.Geometry.Vector2 do
  @moduledoc """
  This module provides a set of functions for working with two dimensional
  vectors.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Point2

  defstruct dx: 0.0, dy: 0.0

  @type t :: %Vector2{dx: number, dy: number}

  @doc """
  Return a vector with the absolute value applied to each component of `vector`.
  """
  @spec abs(t) :: t
  def abs(%Vector2{} = vector) do
    %Vector2{dx: Kernel.abs(vector.dx), dy: Kernel.abs(vector.dy)}
  end

  @doc """
  Adds two vectors returning the resulting vector or adds a vector and a point
  returning the resulting point.
  """
  @spec add(t, t | Point2.t()) :: t | Point2.t()
  def add(vector, vector_or_point)

  def add(%Vector2{} = vector1, %Vector2{} = vector2) do
    %Vector2{dx: vector1.dx + vector2.dx, dy: vector1.dy + vector2.dy}
  end

  def add(%Vector2{} = vector, %Point2{} = point) do
    Point2.add(point, vector)
  end

  @doc """
  Divides each of the components of `vector` by `scalar` and returns the
  resulting vector.
  """
  @spec divide(t, number) :: t
  def divide(%Vector2{} = vector, scalar) do
    multiply(vector, 1.0 / scalar)
  end

  @doc """
  Computes the dot product of two vectors.
  """
  @spec dot(t, t) :: number
  def dot(%Vector2{} = vector1, %Vector2{} = vector2) do
    vector1.dx * vector2.dx + vector1.dy * vector2.dy
  end

  @doc """
  Computes the length of `vector`.
  """
  @spec length(t) :: number
  def length(%Vector2{} = vector) do
    vector |> length_squared() |> :math.sqrt()
  end

  @doc """
  Computes the squared length of `vector`.
  """
  @spec length_squared(t) :: number
  def length_squared(%Vector2{} = vector) do
    vector.dx * vector.dx + vector.dy * vector.dy
  end

  @doc """
  Returns the component of `vector` with the largest value.
  """
  @spec max_component(t) :: number
  def max_component(%Vector2{} = vector) do
    max(vector.dx, vector.dy)
  end

  @doc """
  Returns the component of `vector` with the smallest value.
  """
  @spec min_component(t) :: number
  def min_component(%Vector2{} = vector) do
    min(vector.dx, vector.dy)
  end

  @doc """
  Multiplies each of the component of `vector` by `scalar` and returns the
  resulting vector.
  """
  @spec multiply(t, number) :: t
  def multiply(%Vector2{} = vector, scalar) do
    %Vector2{dx: vector.dx * scalar, dy: vector.dy * scalar}
  end

  @doc """
  Returns the vector pointing in the opposite direction of `vector`.
  """
  @spec negate(t) :: t
  def negate(%Vector2{} = vector) do
    %Vector2{dx: -vector.dx, dy: -vector.dy}
  end

  @doc """
  Normalizes `vector` and returns the resulting vector.
  """
  @spec normalize(t) :: t
  def normalize(%Vector2{} = vector) do
    divide(vector, Vector2.length(vector))
  end

  @doc """
  Subtracts two vectors and returns the resulting vector.
  """
  @spec subtract(t, t) :: t
  def subtract(%Vector2{} = vector1, %Vector2{} = vector2) do
    %Vector2{dx: vector1.dx - vector2.dx, dy: vector1.dy - vector2.dy}
  end
end
