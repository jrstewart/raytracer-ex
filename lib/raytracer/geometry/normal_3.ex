defmodule Raytracer.Geometry.Normal3 do
  @moduledoc """
  This module provides a set of functions for working with three dimensional
  surface normal vectors. A surface normal is a vector that is perpendicular to
  a surface at a specific position. Note that a surface normal is not
  necessarily a normalized vector.
  """

  alias __MODULE__
  alias Raytracer.{Transform, Transformable}
  alias Raytracer.Geometry.Matrix, as: Matrix4x4
  alias Raytracer.Geometry.Vector3

  defstruct dx: 0.0, dy: 0.0, dz: 0.0

  @type t :: %Normal3{dx: number(), dy: number(), dz: number()}

  @doc """
  Return a normal with the absolute value applied to each component of `normal`.
  """
  @spec abs(t()) :: t()
  def abs(%Normal3{} = normal) do
    %Normal3{dx: Kernel.abs(normal.dx), dy: Kernel.abs(normal.dy), dz: Kernel.abs(normal.dz)}
  end

  @doc """
  Adds two normals returning the resulting normal.
  """
  @spec add(t(), t()) :: t()
  def add(%Normal3{} = normal1, %Normal3{} = normal2) do
    %Normal3{
      dx: normal1.dx + normal2.dx,
      dy: normal1.dy + normal2.dy,
      dz: normal1.dz + normal2.dz
    }
  end

  @doc """
  Computes the cross product of `normal` and `vector` and returns the resulting
  vector. Note that computing the cross product of two normals is an undefined
  operation.
  """
  @spec cross(t(), Vector3.t()) :: Vector3.t()
  def cross(%Normal3{} = normal, %Vector3{} = vector) do
    %Vector3{
      dx: normal.dy * vector.dz - normal.dz * vector.dy,
      dy: normal.dz * vector.dx - normal.dx * vector.dz,
      dz: normal.dx * vector.dy - normal.dy * vector.dx
    }
  end

  @doc """
  Divides each of the components of `normal` by `scalar` and returns the
  resulting normal.
  """
  @spec divide(t(), number()) :: t()
  def divide(%Normal3{} = normal, scalar) do
    multiply(normal, 1.0 / scalar)
  end

  @doc """
  Computes the dot product of two normals or a normal and a vector.
  """
  @spec dot(t(), t() | Vector3.t()) :: number()
  def dot(normal, normal_or_vector)

  def dot(%Normal3{} = normal1, %Normal3{} = normal2) do
    normal1.dx * normal2.dx + normal1.dy * normal2.dy + normal1.dz * normal2.dz
  end

  def dot(%Normal3{} = normal, %Vector3{} = vector) do
    normal.dx * vector.dx + normal.dy * vector.dy + normal.dz * vector.dz
  end

  @doc """
  Computes the length of `normal`.
  """
  @spec length(t()) :: number()
  def length(%Normal3{} = normal) do
    normal |> length_squared() |> :math.sqrt()
  end

  @doc """
  Computes the squared length of `normal`.
  """
  @spec length_squared(t()) :: number()
  def length_squared(%Normal3{} = normal) do
    normal.dx * normal.dx + normal.dy * normal.dy + normal.dz * normal.dz
  end

  @doc """
  Multiplies each of the component of `normal` by `scalar` and returns the
  resulting normal.
  """
  @spec multiply(t(), number()) :: t()
  def multiply(%Normal3{} = normal, scalar) do
    %Normal3{dx: normal.dx * scalar, dy: normal.dy * scalar, dz: normal.dz * scalar}
  end

  @doc """
  Returns the normal pointing in the opposite direction of `normal`.
  """
  @spec negate(t()) :: t()
  def negate(%Normal3{} = normal) do
    %Normal3{dx: -normal.dx, dy: -normal.dy, dz: -normal.dz}
  end

  @doc """
  Normalizes `normal` and returns the resulting normal.
  """
  @spec normalize(t()) :: t()
  def normalize(%Normal3{} = normal) do
    divide(normal, Normal3.length(normal))
  end

  @doc """
  Subtracts two normals and returns the resulting normal.
  """
  @spec subtract(t(), t()) :: t()
  def subtract(%Normal3{} = normal1, %Normal3{} = normal2) do
    %Normal3{
      dx: normal1.dx - normal2.dx,
      dy: normal1.dy - normal2.dy,
      dz: normal1.dz - normal2.dz
    }
  end

  defimpl Transformable do
    def apply_transform(%Normal3{} = normal, %Transform{} = transform) do
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
