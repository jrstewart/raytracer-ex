defmodule Raytracer.Geometry.Vector3 do
  @moduledoc """
  Three-dimensional vector represented by components (dx, dy, dz).
  """

  alias __MODULE__
  alias Raytracer.Geometry.Point3

  defstruct [
    dx: 0.0,
    dy: 0.0,
    dz: 0.0,
  ]

  @type t :: %Vector3{dx: number, dy: number, dz: number}

  @doc """
  Return a vector with the absolute value applied to each component of `vector`.
  """
  @spec abs(t) :: t
  def abs(vector)

  def abs(%Vector3{dx: dx, dy: dy, dz: dz}) do
    %Vector3{dx: Kernel.abs(dx), dy: Kernel.abs(dy), dz: Kernel.abs(dz)}
  end

  @doc """
  Adds two vectors returning the resulting vector, or adds a vector and a point
  returning the resulting point.
  """
  @spec add(t, t | Point3.t) :: t | Point3.t
  def add(vector, vector_or_point)

  def add(%Vector3{dx: dx1, dy: dy1, dz: dz1}, %Vector3{dx: dx2, dy: dy2, dz: dz2}) do
    %Vector3{dx: dx1 + dx2, dy: dy1 + dy2, dz: dz1 + dz2}
  end

  def add(%Vector3{dx: dx, dy: dy, dz: dz}, %Point3{x: x, y: y, z: z}) do
    %Point3{x: dx + x, y: dy + y, z: dz + z}
  end

  @doc """
  Computes the cross product of `vector1` and `vector2`.
  """
  @spec cross(t, t) :: t
  def cross(vector1, vector2)

  def cross(%Vector3{dx: dx1, dy: dy1, dz: dz1}, %Vector3{dx: dx2, dy: dy2, dz: dz2}) do
    %Vector3{
      dx: (dy1 * dz2) - (dz1 * dy2),
      dy: (dz1 * dx2) - (dx1 * dz2),
      dz: (dx1 * dy2) - (dy1 * dx2),
    }
  end

  @doc """
  Divides each of the components of `vector` by `scalar` and returns the
  resulting vector. An error is raised if `scalar` is equal to 0.
  """
  @spec divide(t, number) :: t
  def divide(_vector, scalar) when scalar == 0.0 do
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

  def dot(%Vector3{dx: dx1, dy: dy1, dz: dz1}, %Vector3{dx: dx2, dy: dy2, dz: dz2}) do
    (dx1 * dx2) + (dy1 * dy2) + (dz1 * dz2)
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

  def length_squared(%Vector3{dx: dx, dy: dy, dz: dz}) do
    (dx * dx) + (dy * dy) + (dz * dz)
  end

  @doc """
  Returns the component of `vector` with the largest value.
  """
  @spec max_component(t) :: number
  def max_component(vector)

  def max_component(%Vector3{dx: dx, dy: dy, dz: dz}) do
    dx |> max(dy) |> max(dz)
  end

  @doc """
  Returns the component of `vector` with the smallest value.
  """
  @spec min_component(t) :: number
  def min_component(vector)

  def min_component(%Vector3{dx: dx, dy: dy, dz: dz}) do
    dx |> min(dy) |> min(dz)
  end

  @doc """
  Multiplies each of the component of `vector` by `scalar` and returns the
  resulting vector.
  """
  @spec multiply(t, number) :: t
  def multiply(vector, scalar)

  def multiply(%Vector3{dx: dx, dy: dy, dz: dz}, scalar) do
    %Vector3{dx: dx * scalar, dy: dy * scalar, dz: dz * scalar}
  end

  @doc """
  Returns the vector pointing in the opposite direction of `vector`.
  """
  @spec negate(t) :: t
  def negate(vector)

  def negate(%Vector3{dx: dx, dy: dy, dz: dz}) do
    %Vector3{dx: -dx, dy: -dy, dz: -dz}
  end

  @doc """
  Normalizes `vector` and returns the resulting vector.
  """
  @spec normalize(t) :: t
  def normalize(vector) do
    divide(vector, Vector3.length(vector))
  end

  @doc """
  Subtracts two vectors and returns the resulting vector.
  """
  @spec subtract(t, t) :: t
  def subtract(vector1, vector2)

  def subtract(%Vector3{dx: dx1, dy: dy1, dz: dz1}, %Vector3{dx: dx2, dy: dy2, dz: dz2}) do
    %Vector3{dx: dx1 - dx2, dy: dy1 - dy2, dz: dz1 - dz2}
  end
end
