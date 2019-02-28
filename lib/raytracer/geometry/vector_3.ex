defmodule Raytracer.Geometry.Vector3 do
  @moduledoc """
  This module provides a set of functions for working with three dimensional vectors.
  """

  alias __MODULE__
  alias Raytracer.Transformable
  alias Raytracer.Geometry.{Matrix4x4, Normal3, Point3}

  defstruct dx: 0.0, dy: 0.0, dz: 0.0

  @type t :: %Vector3{dx: float, dy: float, dz: float}

  @doc """
  Return a vector with the absolute value applied to each component of `vector`.

  ## Examples

      iex> v = %Vector3{dx: -1.0, dy: -2.0, dz: -3.0}
      iex> Vector3.abs(v)
      %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}

  """
  @spec abs(t) :: t
  def abs(vector),
    do: %Vector3{dx: Kernel.abs(vector.dx), dy: Kernel.abs(vector.dy), dz: Kernel.abs(vector.dz)}

  @doc """
  Adds two vectors returning the resulting vector or adds a vector and a point returning the
  resulting point.

  ## Examples

      iex> v1 = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
      iex> v2 = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}
      iex> Vector3.add(v1, v2)
      %Vector3{dx: 5.0, dy: 7.0, dz: 9.0}

      iex> v = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}
      iex> p = %Point3{x: 1.0, y: 2.0, z: 3.0}
      iex> Vector3.add(v, p)
      %Point3{x: 5.0, y: 7.0, z: 9.0}

  """
  @spec add(t, t | Point3.t()) :: t | Point3.t()
  def add(vector, vector_or_point)

  def add(vector1, %Vector3{} = vector2),
    do: %Vector3{
      dx: vector1.dx + vector2.dx,
      dy: vector1.dy + vector2.dy,
      dz: vector1.dz + vector2.dz
    }

  def add(vector, %Point3{} = point), do: Point3.add(point, vector)

  @doc """
  Computes the cross product of two vectors or a vector and a normal and returns the resulting
  vector.

  ## Examples

      iex> v1 = %Vector3{dx: 2.0, dy: 3.0, dz: 4.0}
      iex> v2 = %Vector3{dx: 5.0, dy: 6.0, dz: 7.0}
      iex> Vector3.cross(v1, v2)
      %Vector3{dx: -3.0, dy: 6.0, dz: -3.0}

      iex> v = %Vector3{dx: 2.0, dy: 3.0, dz: 4.0}
      iex> n = %Normal3{dx: 5.0, dy: 6.0, dz: 7.0}
      iex> Vector3.cross(v, n)
      %Vector3{dx: -3.0, dy: 6.0, dz: -3.0}

  """
  @spec cross(t, t | Normal3.t()) :: t
  def cross(vector, vector_or_normal)

  def cross(vector1, vector2) do
    %Vector3{
      dx: vector1.dy * vector2.dz - vector1.dz * vector2.dy,
      dy: vector1.dz * vector2.dx - vector1.dx * vector2.dz,
      dz: vector1.dx * vector2.dy - vector1.dy * vector2.dx
    }
  end

  @doc """
  Divides each of the components of `vector` by `scalar` and returns the resulting vector.

  ## Examples

      iex> v = %Vector3{dx: 2.0, dy: 4.0, dz: 6.0}
      iex> Vector3.divide(v, 2.0)
      %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}

  """
  @spec divide(t, float) :: t
  def divide(%Vector3{} = vector, scalar), do: multiply(vector, 1 / scalar)

  @doc """
  Computes the dot product of two vectors.

  ## Examples

      iex> v1 = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
      iex> v2 = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}
      iex> Vector3.dot(v1, v2)
      32.0

  """
  @spec dot(t, t) :: float
  def dot(vector1, vector2),
    do: vector1.dx * vector2.dx + vector1.dy * vector2.dy + vector1.dz * vector2.dz

  @doc """
  Computes the length of `vector`.

  ## Examples

      iex> v = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
      iex> Vector3.length(v)
      3.7416573867739413

  """
  @spec length(t) :: float
  def length(vector), do: vector |> length_squared() |> :math.sqrt()

  @doc """
  Computes the squared length of `vector`.

  ## Examples

      iex> v = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
      iex> Vector3.length_squared(v)
      14.0

  """
  @spec length_squared(t) :: float
  def length_squared(vector), do: dot(vector, vector)

  @doc """
  Returns the component of `vector` with the largest value.

  ## Examples

      iex> Vector3.max_component(%Vector3{dx: 1.0, dy: 2.0, dz: 3.0})
      3.0

      iex> Vector3.max_component(%Vector3{dx: 2.0, dy: 4.0, dz: -1.0})
      4.0

      iex> Vector3.max_component(%Vector3{dx: 5.0, dy: 1.0, dz: -2.0})
      5.0

  """
  @spec max_component(t) :: float
  def max_component(vector), do: vector.dx |> max(vector.dy) |> max(vector.dz)

  @doc """
  Returns the component of `vector` with the smallest value.

  ## Examples

      iex> Vector3.min_component(%Vector3{dx: 1.0, dy: 2.0, dz: 3.0})
      1.0

      iex> Vector3.min_component(%Vector3{dx: 2.0, dy: 4.0, dz: -1.0})
      -1.0

      iex> Vector3.min_component(%Vector3{dx: 5.0, dy: -1.0, dz: 2.0})
      -1.0

  """
  @spec min_component(t) :: float
  def min_component(vector), do: vector.dx |> min(vector.dy) |> min(vector.dz)

  @doc """
  Multiplies each of the component of `vector` by `scalar` and returns the
  resulting vector.

  ## Examples

      iex> v = %Vector3{dx: 2.0, dy: 4.0, dz: 6.0}
      iex> Vector3.multiply(v, 2.0)
      %Vector3{dx: 4.0, dy: 8.0, dz: 12.0}

  """
  @spec multiply(t, float) :: t
  def multiply(vector, scalar),
    do: %Vector3{dx: vector.dx * scalar, dy: vector.dy * scalar, dz: vector.dz * scalar}

  @doc """
  Returns the vector pointing in the opposite direction of `vector`.

  ## Examples

      iex> v = %Vector3{dx: 1.0, dy: 2.0, dz: -1.0}
      iex> Vector3.negate(v)
      %Vector3{dx: -1.0, dy: -2.0, dz: 1.0}

  """
  @spec negate(t) :: t
  def negate(vector), do: %Vector3{dx: -vector.dx, dy: -vector.dy, dz: -vector.dz}

  @doc """
  Normalizes `vector` and returns the resulting vector.

  ## Examples

      iex> v = %Vector3{dx: 10.0, dy: 8.0, dz: 5.0}
      iex> Vector3.normalize(v)
      %Vector3{dx: 0.727392967453308, dy: 0.5819143739626463, dz: 0.363696483726654}

  """
  @spec normalize(t) :: t
  def normalize(vector), do: divide(vector, Vector3.length(vector))

  @doc """
  Subtracts two vectors and returns the resulting vector.

  ## Examples

      iex> v1 = %Vector3{dx: 1.0, dy: 5.0, dz: 4.0}
      iex> v2 = %Vector3{dx: 2.0, dy: 3.0, dz: 7.0}
      iex> Vector3.subtract(v1, v2)
      %Vector3{dx: -1.0, dy: 2.0, dz: -3.0}

  """
  @spec subtract(t, t) :: t
  def subtract(vector1, vector2) do
    %Vector3{
      dx: vector1.dx - vector2.dx,
      dy: vector1.dy - vector2.dy,
      dz: vector1.dz - vector2.dz
    }
  end

  @doc """
  Converts `vector` into a surface normal.

  ## Examples

      iex> v = %Vector3{dx: 1.0, dy: -1.0, dz: 2.0}
      iex> Vector3.to_normal(v)
      %Normal3{dx: 1.0, dy: -1.0, dz: 2.0}

  """
  @spec to_normal(t) :: Normal3.t()
  def to_normal(vector), do: %Normal3{dx: vector.dx, dy: vector.dy, dz: vector.dz}

  @doc """
  Returns the zero vector.

  ## Example

      iex> Vector3.zero()
      %Vector3{dx: 0.0, dy: 0.0, dz: 0.0}

  """
  @spec zero :: t
  def zero, do: %Vector3{dx: 0.0, dy: 0.0, dz: 0.0}

  defimpl Transformable do
    def apply_transform(vector, transform) do
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
