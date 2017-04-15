defmodule Raytracer.Geometry.Normal do
  @moduledoc """
  This module provides a set of functions for working with three dimensional
  surface normal vectors represented by a tuple `{dx, dy, dz}`. A surface normal
  is a vector that is perpendicular to a surface at a specific position. Note
  that a surface normal is not necessarily a normalized vector.
  """

  alias Raytracer.Geometry.Vector
  alias Raytracer.Transform

  @type t :: {number, number, number}

  @doc """
  Return a normal with the absolute value applied to each component of `normal`.
  """
  @spec abs(t) :: t
  def abs(normal), do: Vector.abs(normal)

  @doc """
  Adds two normals returning the resulting normal.
  """
  @spec add(t, t) :: t
  def add(normal1, normal2), do: Vector.add(normal1, normal2)

  @doc """
  Applies `transform` to `normal` and returns the resulting normal.
  """
  @spec apply_transform(t, Transform.t) :: t
  def apply_transform(normal, transform)
  def apply_transform({dx, dy, dz}, %Transform{inverse_matrix: m}) do
    {elem(m, 0) * dx + elem(m, 4) * dy + elem(m, 8) * dz,
     elem(m, 1) * dx + elem(m, 5) * dy + elem(m, 9) * dz,
     elem(m, 2) * dx + elem(m, 6) * dy + elem(m, 10) * dz}
  end

  @doc """
  Computes the cross product of `normal` and `vector` and returns the resulting
  vector. Note that computing the cross product of two normals is an undefined
  operations.
  """
  @spec cross(t, Vector.vector3_t) :: Vector.vector3_t
  def cross(normal, vector), do: Vector.cross(normal, vector)

  @doc """
  Divides each of the components of `normal` by `scalar` and returns the
  resulting normal.
  """
  @spec divide(t, number) :: t
  def divide(normal, scalar), do: Vector.divide(normal, scalar)

  @doc """
  Computes the dot product of two normals or a normal and a vector.
  """
  @spec dot(t, t | Vector.vector3_t) :: number
  def dot(normal, normal_or_vector), do: Vector.dot(normal, normal_or_vector)

  @doc """
  Computes the length of `normal`.
  """
  @spec length(t) :: float
  def length(normal), do: Vector.length(normal)

  @doc """
  Computes the squared length of `normal`.
  """
  @spec length_squared(t) :: number
  def length_squared(normal), do: Vector.length_squared(normal)

  @doc """
  Multiplies each of the component of `normal` by `scalar` and returns the
  resulting normal.
  """
  @spec multiply(t, number) :: t
  def multiply(normal, scalar), do: Vector.multiply(normal, scalar)

  @doc """
  Returns the normal pointing in the opposite direction of `normal`.
  """
  @spec negate(t) :: t
  def negate(normal), do: Vector.negate(normal)

  @doc """
  Normalizes `normal` and returns the resulting normal.
  """
  @spec normalize(t) :: t
  def normalize(normal), do: Vector.normalize(normal)

  @doc """
  Subtracts two normals and returns the resulting normal.
  """
  @spec subtract(t, t) :: t
  def subtract(normal1, normal2), do: Vector.subtract(normal1, normal2)
end
