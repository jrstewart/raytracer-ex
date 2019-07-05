defmodule Raytracer.Geometry.Normal3 do
  @moduledoc """
  This module provides a set of functions for working with three dimensional surface normal vectors.
  A surface normal is a vector that is perpendicular to a surface at a specific position. Note that
  a surface normal is not necessarily a normalized vector.
  """

  alias __MODULE__
  alias Raytracer.Transformable
  alias Raytracer.Geometry.{Matrix4x4, Vector3}

  defstruct dx: 0.0, dy: 0.0, dz: 0.0

  @type t :: %Normal3{dx: float, dy: float, dz: float}

  @doc """
  Return a normal with the absolute value applied to each component of `normal`.
  """
  @spec abs(t) :: t
  def abs(normal) do
    %Normal3{dx: Kernel.abs(normal.dx), dy: Kernel.abs(normal.dy), dz: Kernel.abs(normal.dz)}
  end

  @doc """
  Adds two normals returning the resulting normal.
  """
  @spec add(t, t) :: t
  def add(normal1, normal2) do
    %Normal3{
      dx: normal1.dx + normal2.dx,
      dy: normal1.dy + normal2.dy,
      dz: normal1.dz + normal2.dz
    }
  end

  @doc """
  Computes the cross product of `normal` and `vector` and returns the resulting vector. Note that
  computing the cross product of two normals is an undefined operation.
  """
  @spec cross(t, Vector3.t()) :: Vector3.t()
  def cross(normal, vector) do
    %Vector3{
      dx: normal.dy * vector.dz - normal.dz * vector.dy,
      dy: normal.dz * vector.dx - normal.dx * vector.dz,
      dz: normal.dx * vector.dy - normal.dy * vector.dx
    }
  end

  @doc """
  Divides each of the components of `normal` by `scalar` and returns the resulting normal.
  """
  @spec divide(t, float) :: t
  def divide(normal, scalar), do: multiply(normal, 1.0 / scalar)

  @doc """
  Computes the dot product of two normals or a normal and a vector.
  """
  @spec dot(t, t | Vector3.t()) :: float
  def dot(normal, normal_or_vector) do
    normal.dx * normal_or_vector.dx +
      normal.dy * normal_or_vector.dy +
      normal.dz * normal_or_vector.dz
  end

  @doc """
  Computes the length of `normal`.
  """
  @spec length(t) :: float
  def length(normal), do: normal |> length_squared() |> :math.sqrt()

  @doc """
  Computes the squared length of `normal`.
  """
  @spec length_squared(t) :: float
  def length_squared(normal),
    do: normal.dx * normal.dx + normal.dy * normal.dy + normal.dz * normal.dz

  @doc """
  Multiplies each of the component of `normal` by `scalar` and returns the resulting normal.
  """
  @spec multiply(t, float) :: t
  def multiply(normal, scalar),
    do: %Normal3{dx: normal.dx * scalar, dy: normal.dy * scalar, dz: normal.dz * scalar}

  @doc """
  Returns the normal pointing in the opposite direction of `normal`.
  """
  @spec negate(t) :: t
  def negate(normal), do: %Normal3{dx: -normal.dx, dy: -normal.dy, dz: -normal.dz}

  @doc """
  Normalizes `normal` and returns the resulting normal.
  """
  @spec normalize(t) :: t
  def normalize(normal), do: divide(normal, Normal3.length(normal))

  @doc """
  Subtracts two normals and returns the resulting normal.
  """
  @spec subtract(t, t) :: t
  def subtract(normal1, normal2) do
    %Normal3{
      dx: normal1.dx - normal2.dx,
      dy: normal1.dy - normal2.dy,
      dz: normal1.dz - normal2.dz
    }
  end

  defimpl Transformable do
    def apply_transform(normal, transform) do
      dx =
        Matrix4x4.elem(transform.inverse_matrix, 0, 0) * normal.dx +
          Matrix4x4.elem(transform.inverse_matrix, 1, 0) * normal.dy +
          Matrix4x4.elem(transform.inverse_matrix, 2, 0) * normal.dz

      dy =
        Matrix4x4.elem(transform.inverse_matrix, 0, 1) * normal.dx +
          Matrix4x4.elem(transform.inverse_matrix, 1, 1) * normal.dy +
          Matrix4x4.elem(transform.inverse_matrix, 2, 1) * normal.dz

      dz =
        Matrix4x4.elem(transform.inverse_matrix, 0, 2) * normal.dx +
          Matrix4x4.elem(transform.inverse_matrix, 1, 2) * normal.dy +
          Matrix4x4.elem(transform.inverse_matrix, 2, 2) * normal.dz

      %Normal3{dx: dx, dy: dy, dz: dz}
    end
  end
end
