defmodule Raytracer.Transform do
  @moduledoc """
  This module provides a representation and functions for working geometric
  transformations.
  """

  alias __MODULE__
  alias Raytracer.Geometry
  alias Raytracer.Geometry.{Matrix, Point, Vector}

  defstruct [
    matrix: {
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0,
      0.0, 0.0, 0.0, 1.0,
    },
    inverse_matrix: {
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0,
      0.0, 0.0, 0.0, 1.0,
    }
  ]

  @type t :: %Transform{matrix: Matrix.matrix4x4_t, inverse_matrix: Matrix.matrix4x4_t}

  @doc """
  Creates a transform from `matrix`.
  """
  @spec from_matrix(Matrix.matrix4x4_t) :: t
  def from_matrix(matrix) do
    %Transform{matrix: matrix, inverse_matrix: Matrix.inverse(matrix)}
  end

  @doc """
  Tests if `transform` is a scaling transform.
  """
  @spec has_scale?(t) :: boolean
  def has_scale?(transform) do
    length1 = {1, 0, 0} |> Vector.apply_transform(transform) |> Vector.length_squared
    length2 = {0, 1, 0} |> Vector.apply_transform(transform) |> Vector.length_squared
    length3 = {0, 0, 1} |> Vector.apply_transform(transform) |> Vector.length_squared
    not_one?(length1) || not_one?(length2) || not_one?(length3)
  end

  defp not_one?(value), do: value < 0.999 || value > 1.001

  @doc """
  Computes a look at transformation for a camera at `position` focused on
  `center` and an orientation specified by the `up` vector.
  """
  @spec look_at(Point.point3_t, Point.point3_t, Vector.vector3_t) :: t
  def look_at({position_x, position_y, position_z} = position, center, up) do
    direction = center |> Point.subtract(position) |> Vector.normalize
    left = up |> Vector.normalize |> Vector.cross(direction) |> Vector.normalize
    new_up = Vector.cross(direction, left)
    m = {
      elem(left, 0), elem(new_up, 0), elem(direction, 0), position_x,
      elem(left, 1), elem(new_up, 1), elem(direction, 1), position_y,
      elem(left, 2), elem(new_up, 2), elem(direction, 2), position_z,
      0.0,           0.0,             0.0,                1.0,
    }
    %Transform{matrix: m, inverse_matrix: Matrix.inverse(m)}
  end

  @doc """
  Creates a transform that is the inverse transform of `transform`.
  """
  @spec inverse(t) :: t
  def inverse(transform)
  def inverse(%Transform{matrix: matrix, inverse_matrix: inverse_matrix}) do
    %Transform{matrix: inverse_matrix, inverse_matrix: matrix}
  end

  @doc """
  Creates a transform that is a rotation about `axis` by `degrees`.
  """
  @spec rotate(float, Vector.vector3_t) :: t
  def rotate(degrees, axis) do
    {dx, dy, dz} = Vector.normalize(axis)
    radian_angle = Geometry.degrees_to_radians(degrees)
    sin_angle = :math.sin(radian_angle)
    cos_angle = :math.cos(radian_angle)
    m = {
      dx * dx + (1 - dx * dx) * cos_angle,
      dx * dy * (1 - cos_angle) - dz * sin_angle,
      dx * dz * (1 - cos_angle) + dy * sin_angle,
      0.0,
      dx * dy * (1 - cos_angle) + dz * sin_angle,
      dy * dy + (1 - dy * dy) * cos_angle,
      dy * dz * (1 - cos_angle) - dx * sin_angle,
      0.0,
      dx * dz * (1 - cos_angle) - dy * sin_angle,
      dy * dz * (1 - cos_angle) + dx * sin_angle,
      dz * dz + (1 - dz * dz) * cos_angle,
      0.0,
      0.0, 0.0, 0.0, 1.0,
    }
    %Transform{matrix: m, inverse_matrix: Matrix.transpose(m)}
  end

  @doc """
  Creates a transform that is a rotation about the x-axis by `degrees`.
  """
  @spec rotate_x(float) :: t
  def rotate_x(degrees) do
    radian_angle = Geometry.degrees_to_radians(degrees)
    sin_angle = :math.sin(radian_angle)
    cos_angle = :math.cos(radian_angle)
    m = {
      1.0, 0.0,       0.0,        0.0,
      0.0, cos_angle, -sin_angle, 0.0,
      0.0, sin_angle, cos_angle,  0.0,
      0.0, 0.0,       0.0,        1.0,
    }
    %Transform{matrix: m, inverse_matrix: Matrix.transpose(m)}
  end

  @doc """
  Creates a transform that is a rotation about the y-axis by `degrees`.
  """
  @spec rotate_y(float) :: t
  def rotate_y(degrees) do
    radian_angle = Geometry.degrees_to_radians(degrees)
    sin_angle = :math.sin(radian_angle)
    cos_angle = :math.cos(radian_angle)
    m = {
      cos_angle,  0.0, sin_angle, 0.0,
      0.0,        1.0, 0.0,       0.0,
      -sin_angle, 0.0, cos_angle, 0.0,
      0.0,        0.0, 0.0,       1.0,
    }
    %Transform{matrix: m, inverse_matrix: Matrix.transpose(m)}
  end

  @doc """
  Creates a transform that is a rotation about the z-axis by `degrees`.
  """
  @spec rotate_z(float) :: t
  def rotate_z(degrees) do
    radian_angle = Geometry.degrees_to_radians(degrees)
    sin_angle = :math.sin(radian_angle)
    cos_angle = :math.cos(radian_angle)
    m = {
      cos_angle, -sin_angle, 0.0, 0.0,
      sin_angle, cos_angle,  0.0, 0.0,
      0.0,       0.0,        1.0, 0.0,
      0.0,       0.0,        0.0, 1.0,
    }
    %Transform{matrix: m, inverse_matrix: Matrix.transpose(m)}
  end

  @doc """
  Creates a scaling transform based on the sx, sy, and sz values of `factors`.
  """
  def scale(factors)
  def scale({sx, sy, sz}) do
    %Transform{
      matrix: {
        sx,  0.0, 0.0, 0.0,
        0.0, sy,  0.0, 0.0,
        0.0, 0.0, sz,  0.0,
        0.0, 0.0, 0.0, 1.0,
      },
      inverse_matrix: {
        1.0 / sx, 0.0,      0.0,      0.0,
        0.0,      1.0 / sy, 0.0,      0.0,
        0.0,      0.0,      1.0 / sz, 0.0,
        0.0,      0.0,      0.0,      1.0,
      }
    }
  end

  @doc """
  Creates a translation transform based on the dx, dy, and dz values of `deltas`.
  """
  @spec translate({float, float, float}) :: t
  def translate(deltas)
  def translate({dx, dy, dz}) do
    %Transform{
      matrix: {
        1.0, 0.0, 0.0, dx,
        0.0, 1.0, 0.0, dy,
        0.0, 0.0, 1.0, dz,
        0.0, 0.0, 0.0, 1.0,
      },
      inverse_matrix: {
        1.0, 0.0, 0.0, -dx,
        0.0, 1.0, 0.0, -dy,
        0.0, 0.0, 1.0, -dz,
        0.0, 0.0, 0.0, 1.0,
      }
    }
  end

  @doc """
  Transposes the matrices of `transform` and returns the resulting transform.
  """
  @spec transpose(t) :: t
  def transpose(transform)
  def transpose(%Transform{matrix: matrix, inverse_matrix: inverse_matrix}) do
    %Transform{matrix: Matrix.transpose(matrix), inverse_matrix: Matrix.transpose(inverse_matrix)}
  end
end
