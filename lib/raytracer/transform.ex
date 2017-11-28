defmodule Raytracer.Transform do
  @moduledoc """
  This module provides a representation and functions for working geometric
  transformations.
  """

  alias __MODULE__
  alias Raytracer.{Geometry, Transformable}
  alias Raytracer.Geometry.{Matrix4x4, Point3, Vector3}

  defstruct matrix: Matrix4x4.identity_matrix(), inverse_matrix: Matrix4x4.identity_matrix()

  @type t :: %Transform{matrix: Matrix4x4.t(), inverse_matrix: Matrix4x4.t()}

  @doc """
  Creates a transform from `matrix`.
  """
  @spec from_matrix(Matrix4x4.t()) :: t()
  def from_matrix(%Matrix4x4{} = matrix) do
    %Transform{matrix: matrix, inverse_matrix: Matrix4x4.inverse(matrix)}
  end

  @doc """
  Tests if `transform` is a scaling transform.
  """
  @spec has_scale?(t()) :: boolean()
  def has_scale?(%Transform{} = transform) do
    %Vector3{dx: 1, dy: 0, dz: 0} |> transformed_length_squared(transform) |> not_one?() ||
      %Vector3{dx: 0, dy: 1, dz: 0} |> transformed_length_squared(transform) |> not_one?() ||
      %Vector3{dx: 0, dy: 0, dz: 1} |> transformed_length_squared(transform) |> not_one?()
  end

  defp transformed_length_squared(vector, transform) do
    vector |> Transformable.apply_transform(transform) |> Vector3.length_squared()
  end

  defp not_one?(value), do: value < 0.999 || value > 1.001

  @doc """
  Creates a transform that is the inverse transform of `transform`.
  """
  @spec inverse(t()) :: t()
  def inverse(%Transform{} = transform) do
    %Transform{matrix: transform.inverse_matrix, inverse_matrix: transform.matrix}
  end

  @doc """
  Computes a look at transformation for a camera at `position` focused on
  `center` and an orientation specified by the `up` vector.
  """
  @spec look_at(Point3.t(), Point3.t(), Vector3.t()) :: t()
  def look_at(%Point3{} = position, %Point3{} = center, %Vector3{} = up) do
    direction = center |> Point3.subtract(position) |> Vector3.normalize()
    left = up |> Vector3.normalize() |> Vector3.cross(direction) |> Vector3.normalize()
    new_up = Vector3.cross(direction, left)

    matrix =
      Matrix4x4.new(
        {left.dx, new_up.dx, direction.dx, position.x},
        {left.dy, new_up.dy, direction.dy, position.y},
        {left.dz, new_up.dz, direction.dz, position.z},
        {0.0, 0.0, 0.0, 1.0}
      )

    %Transform{matrix: matrix, inverse_matrix: Matrix4x4.inverse(matrix)}
  end

  @doc """
  Multiplies two transforms returning the resulting transform.
  """
  @spec multiply(t(), t()) :: t()
  def multiply(%Transform{} = transform1, %Transform{} = transform2) do
    %Transform{
      matrix: Matrix4x4.multiply(transform1.matrix, transform2.matrix),
      inverse_matrix: Matrix4x4.multiply(transform2.inverse_matrix, transform1.inverse_matrix)
    }
  end

  @doc """
  Creates a transform that is a rotation about `axis` by `degrees`.
  """
  @spec rotate(float(), Vector3.t()) :: t()
  def rotate(degrees, %Vector3{} = axis) do
    %Vector3{dx: dx, dy: dy, dz: dz} = Vector3.normalize(axis)
    radian_angle = Geometry.degrees_to_radians(degrees)
    sin_angle = :math.sin(radian_angle)
    cos_angle = :math.cos(radian_angle)

    matrix =
      Matrix4x4.new(
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
        0.0,
        0.0,
        0.0,
        1.0
      )

    %Transform{matrix: matrix, inverse_matrix: Matrix4x4.transpose(matrix)}
  end

  @doc """
  Creates a transform that is a rotation about the x-axis by `degrees`.
  """
  @spec rotate_x(float()) :: t()
  def rotate_x(degrees) do
    radian_angle = Geometry.degrees_to_radians(degrees)
    sin_angle = :math.sin(radian_angle)
    cos_angle = :math.cos(radian_angle)

    matrix =
      Matrix4x4.new(
        {1.0, 0.0, 0.0, 0.0},
        {0.0, cos_angle, -sin_angle, 0.0},
        {0.0, sin_angle, cos_angle, 0.0},
        {0.0, 0.0, 0.0, 1.0}
      )

    %Transform{matrix: matrix, inverse_matrix: Matrix4x4.transpose(matrix)}
  end

  @doc """
  Creates a transform that is a rotation about the y-axis by `degrees`.
  """
  @spec rotate_y(float()) :: t()
  def rotate_y(degrees) do
    radian_angle = Geometry.degrees_to_radians(degrees)
    sin_angle = :math.sin(radian_angle)
    cos_angle = :math.cos(radian_angle)

    matrix =
      Matrix4x4.new(
        {cos_angle, 0.0, sin_angle, 0.0},
        {0.0, 1.0, 0.0, 0.0},
        {-sin_angle, 0.0, cos_angle, 0.0},
        {0.0, 0.0, 0.0, 1.0}
      )

    %Transform{matrix: matrix, inverse_matrix: Matrix4x4.transpose(matrix)}
  end

  @doc """
  Creates a transform that is a rotation about the z-axis by `degrees`.
  """
  @spec rotate_z(float()) :: t()
  def rotate_z(degrees) do
    radian_angle = Geometry.degrees_to_radians(degrees)
    sin_angle = :math.sin(radian_angle)
    cos_angle = :math.cos(radian_angle)

    matrix =
      Matrix4x4.new(
        {cos_angle, -sin_angle, 0.0, 0.0},
        {sin_angle, cos_angle, 0.0, 0.0},
        {0.0, 0.0, 1.0, 0.0},
        {0.0, 0.0, 0.0, 1.0}
      )

    %Transform{matrix: matrix, inverse_matrix: Matrix4x4.transpose(matrix)}
  end

  @doc """
  Creates a scaling transform based on the `sx`, `sy`, and `sz` values that
  define the scale factor in the direction of each coordinate axis.
  """
  @spec scale(float(), float(), float()) :: t()
  def scale(sx, sy, sz) do
    %Transform{
      matrix:
        Matrix4x4.new(
          {sx, 0.0, 0.0, 0.0},
          {0.0, sy, 0.0, 0.0},
          {0.0, 0.0, sz, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        ),
      inverse_matrix:
        Matrix4x4.new(
          {1.0 / sx, 0.0, 0.0, 0.0},
          {0.0, 1.0 / sy, 0.0, 0.0},
          {0.0, 0.0, 1.0 / sz, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )
    }
  end

  @doc """
  Tests if applying `transform` switches the handedness of the coordinate system
  from left-handed to right-handed or vice versa.
  """
  @spec swaps_handedness?(t()) :: boolean()
  def swaps_handedness?(%Transform{} = transform) do
    det =
      Matrix4x4.elem(transform.matrix, 0, 0) *
        (Matrix4x4.elem(transform.matrix, 1, 1) * Matrix4x4.elem(transform.matrix, 2, 2) -
           Matrix4x4.elem(transform.matrix, 1, 2) * Matrix4x4.elem(transform.matrix, 2, 1)) -
        Matrix4x4.elem(transform.matrix, 0, 1) *
          (Matrix4x4.elem(transform.matrix, 1, 0) * Matrix4x4.elem(transform.matrix, 2, 2) -
             Matrix4x4.elem(transform.matrix, 1, 2) * Matrix4x4.elem(transform.matrix, 2, 0)) +
        Matrix4x4.elem(transform.matrix, 0, 2) *
          (Matrix4x4.elem(transform.matrix, 1, 0) * Matrix4x4.elem(transform.matrix, 2, 1) -
             Matrix4x4.elem(transform.matrix, 1, 1) * Matrix4x4.elem(transform.matrix, 2, 0))

    det < 0
  end

  @doc """
  Creates a translation transform based on the `dx`, `dy`, and `dz` values that
  define the translation factor in the direction of each coordinate axis.
  """
  @spec translate(float(), float(), float()) :: t()
  def translate(dx, dy, dz) do
    %Transform{
      matrix:
        Matrix4x4.new(
          {1.0, 0.0, 0.0, dx},
          {0.0, 1.0, 0.0, dy},
          {0.0, 0.0, 1.0, dz},
          {0.0, 0.0, 0.0, 1.0}
        ),
      inverse_matrix:
        Matrix4x4.new(
          {1.0, 0.0, 0.0, -dx},
          {0.0, 1.0, 0.0, -dy},
          {0.0, 0.0, 1.0, -dz},
          {0.0, 0.0, 0.0, 1.0}
        )
    }
  end

  @doc """
  Transposes the matrices of `transform` and returns the resulting transform.
  """
  @spec transpose(t()) :: t()
  def transpose(%Transform{} = transform) do
    %Transform{
      matrix: Matrix4x4.transpose(transform.matrix),
      inverse_matrix: Matrix4x4.transpose(transform.inverse_matrix)
    }
  end
end
