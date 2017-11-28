defmodule Raytracer.Geometry.Vector3 do
  @moduledoc """
  This module provides a set of functions for working with three dimensional
  vectors.
  """

  alias __MODULE__
  alias Raytracer.{Transform, Transformable}
  alias Raytracer.Geometry.{Matrix4x4, Normal3, Point3}

  defstruct dx: 0.0, dy: 0.0, dz: 0.0

  @type t :: %Vector3{dx: number(), dy: number(), dz: number()}

  @doc """
  Return a vector with the absolute value applied to each component of `vector`.
  """
  @spec abs(t()) :: t()
  def abs(%Vector3{} = vector) do
    %Vector3{dx: Kernel.abs(vector.dx), dy: Kernel.abs(vector.dy), dz: Kernel.abs(vector.dz)}
  end

  @doc """
  Adds two vectors returning the resulting vector or adds a vector and a point
  returning the resulting point.
  """
  @spec add(t(), t() | Point3.t()) :: t() | Point3.t()
  def add(vector, vector_or_point)

  def add(%Vector3{} = vector1, %Vector3{} = vector2) do
    %Vector3{
      dx: vector1.dx + vector2.dx,
      dy: vector1.dy + vector2.dy,
      dz: vector1.dz + vector2.dz
    }
  end

  def add(%Vector3{} = vector, %Point3{} = point) do
    Point3.add(point, vector)
  end

  @doc """
  Computes the cross product of two vectors or a vector and a normal and returns
  the resulting vector.
  """
  @spec cross(t(), t() | Normal3.t()) :: t()
  def cross(vector, vector_or_normal)

  def cross(%Vector3{} = vector1, %Vector3{} = vector2) do
    %Vector3{
      dx: vector1.dy * vector2.dz - vector1.dz * vector2.dy,
      dy: vector1.dz * vector2.dx - vector1.dx * vector2.dz,
      dz: vector1.dx * vector2.dy - vector1.dy * vector2.dx
    }
  end

  def cross(%Vector3{} = vector, %Normal3{} = normal) do
    %Vector3{
      dx: vector.dy * normal.dz - vector.dz * normal.dy,
      dy: vector.dz * normal.dx - vector.dx * normal.dz,
      dz: vector.dx * normal.dy - vector.dy * normal.dx
    }
  end

  @doc """
  Divides each of the components of `vector` by `scalar` and returns the
  resulting vector.
  """
  @spec divide(t(), number()) :: t()
  def divide(%Vector3{} = vector, scalar) do
    multiply(vector, 1.0 / scalar)
  end

  @doc """
  Computes the dot product of two vectors.
  """
  @spec dot(t(), t()) :: number()
  def dot(%Vector3{} = vector1, %Vector3{} = vector2) do
    vector1.dx * vector2.dx + vector1.dy * vector2.dy + vector1.dz * vector2.dz
  end

  @doc """
  Computes the length of `vector`.
  """
  @spec length(t()) :: number()
  def length(%Vector3{} = vector) do
    vector |> length_squared() |> :math.sqrt()
  end

  @doc """
  Computes the squared length of `vector`.
  """
  @spec length_squared(t()) :: number()
  def length_squared(%Vector3{} = vector) do
    vector.dx * vector.dx + vector.dy * vector.dy + vector.dz * vector.dz
  end

  @doc """
  Returns the component of `vector` with the largest value.
  """
  @spec max_component(t()) :: number()
  def max_component(%Vector3{} = vector) do
    vector.dx |> max(vector.dy) |> max(vector.dz)
  end

  @doc """
  Returns the component of `vector` with the smallest value.
  """
  @spec min_component(t()) :: number()
  def min_component(%Vector3{} = vector) do
    vector.dx |> min(vector.dy) |> min(vector.dz)
  end

  @doc """
  Multiplies each of the component of `vector` by `scalar` and returns the
  resulting vector.
  """
  @spec multiply(t(), number()) :: t()
  def multiply(%Vector3{} = vector, scalar) do
    %Vector3{dx: vector.dx * scalar, dy: vector.dy * scalar, dz: vector.dz * scalar}
  end

  @doc """
  Returns the vector pointing in the opposite direction of `vector`.
  """
  @spec negate(t()) :: t()
  def negate(%Vector3{} = vector) do
    %Vector3{dx: -vector.dx, dy: -vector.dy, dz: -vector.dz}
  end

  @doc """
  Normalizes `vector` and returns the resulting vector.
  """
  @spec normalize(t()) :: t()
  def normalize(%Vector3{} = vector) do
    divide(vector, Vector3.length(vector))
  end

  @doc """
  Subtracts two vectors and returns the resulting vector.
  """
  @spec subtract(t(), t()) :: t()
  def subtract(%Vector3{} = vector1, %Vector3{} = vector2) do
    %Vector3{
      dx: vector1.dx - vector2.dx,
      dy: vector1.dy - vector2.dy,
      dz: vector1.dz - vector2.dz
    }
  end

  @doc """
  Converts `vector` into a surface normal.
  """
  @spec to_normal(t()) :: Normal3.t()
  def to_normal(%Vector3{} = vector) do
    %Normal3{dx: vector.dx, dy: vector.dy, dz: vector.dz}
  end

  defimpl Transformable do
    def apply_transform(%Vector3{} = vector, %Transform{} = transform) do
      dx =
        Matrix4x4.elem(transform.matrix, 0, 0) * vector.dx +
          Matrix4x4.elem(transform.matrix, 0, 1) * vector.dy +
          Matrix4x4.elem(transform.matrix, 0, 2) * vector.dz

      dy =
        Matrix4x4.elem(transform.matrix, 1, 0) * vector.dx +
          Matrix4x4.elem(transform.matrix, 1, 1) * vector.dy +
          Matrix4x4.elem(transform.matrix, 1, 2) * vector.dz

      dz =
        Matrix4x4.elem(transform.matrix, 2, 0) * vector.dx +
          Matrix4x4.elem(transform.matrix, 2, 1) * vector.dy +
          Matrix4x4.elem(transform.matrix, 2, 2) * vector.dz

      %Vector3{dx: dx, dy: dy, dz: dz}
    end
  end
end
