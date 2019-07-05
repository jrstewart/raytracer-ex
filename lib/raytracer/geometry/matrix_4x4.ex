defmodule Raytracer.Geometry.Matrix4x4 do
  @moduledoc """
  This module provides a set of functions for working with 4x4 matrices. The matrix elements for the
  defined struct are stored in row-major order.
  """

  alias __MODULE__

  defstruct elements: {
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0,
              0.0
            }

  @type t :: %Matrix4x4{
          elements: {
            float,
            float,
            float,
            float,
            float,
            float,
            float,
            float,
            float,
            float,
            float,
            float,
            float,
            float,
            float,
            float
          }
        }

  @compile {:inline, elem: 3, identity_matrix: 0}

  @doc """
  Returns a diagonal matrix with the diagonal elements set to the given values. A diagonal matrix is
  a matrix in which the elements outside the main diagonal equal zero.
  """
  @spec diagonal_matrix(float, float, float, float) :: t
  def diagonal_matrix(m00, m11, m22, m33) do
    Matrix4x4.new(
      {m00, 0.0, 0.0, 0.0},
      {0.0, m11, 0.0, 0.0},
      {0.0, 0.0, m22, 0.0},
      {0.0, 0.0, 0.0, m33}
    )
  end

  @doc """
  Computes the determinant of the matrix `m`
  """
  @spec determinant(t) :: float
  def determinant(m) do
    # Compute the 2x2 determinants of the matrix
    det1 = elem(m, 0, 0) * elem(m, 1, 1) - elem(m, 1, 0) * elem(m, 0, 1)
    det2 = elem(m, 0, 0) * elem(m, 1, 2) - elem(m, 0, 2) * elem(m, 1, 0)
    det3 = elem(m, 0, 0) * elem(m, 1, 3) - elem(m, 0, 3) * elem(m, 1, 0)
    det4 = elem(m, 0, 1) * elem(m, 1, 2) - elem(m, 0, 2) * elem(m, 1, 1)
    det5 = elem(m, 0, 1) * elem(m, 1, 3) - elem(m, 0, 3) * elem(m, 1, 1)
    det6 = elem(m, 0, 2) * elem(m, 1, 3) - elem(m, 0, 3) * elem(m, 1, 2)
    det7 = elem(m, 2, 0) * elem(m, 3, 1) - elem(m, 2, 1) * elem(m, 3, 0)
    det8 = elem(m, 2, 0) * elem(m, 3, 2) - elem(m, 2, 2) * elem(m, 3, 0)
    det9 = elem(m, 2, 0) * elem(m, 3, 3) - elem(m, 2, 3) * elem(m, 3, 0)
    det10 = elem(m, 2, 1) * elem(m, 3, 2) - elem(m, 2, 2) * elem(m, 3, 1)
    det11 = elem(m, 2, 1) * elem(m, 3, 3) - elem(m, 2, 3) * elem(m, 3, 1)
    det12 = elem(m, 2, 2) * elem(m, 3, 3) - elem(m, 3, 2) * elem(m, 2, 3)

    det1 * det12 - det2 * det11 + det3 * det10 + det4 * det9 - det5 * det8 + det6 * det7
  end

  @doc """
  Returns the matrix element at the given row, column index.
  """
  @spec elem(t, 0..3, 0..3) :: float
  def elem(m, row, column)
  def elem(m, 0, 0), do: Kernel.elem(m.elements, 0)
  def elem(m, 0, 1), do: Kernel.elem(m.elements, 1)
  def elem(m, 0, 2), do: Kernel.elem(m.elements, 2)
  def elem(m, 0, 3), do: Kernel.elem(m.elements, 3)
  def elem(m, 1, 0), do: Kernel.elem(m.elements, 4)
  def elem(m, 1, 1), do: Kernel.elem(m.elements, 5)
  def elem(m, 1, 2), do: Kernel.elem(m.elements, 6)
  def elem(m, 1, 3), do: Kernel.elem(m.elements, 7)
  def elem(m, 2, 0), do: Kernel.elem(m.elements, 8)
  def elem(m, 2, 1), do: Kernel.elem(m.elements, 9)
  def elem(m, 2, 2), do: Kernel.elem(m.elements, 10)
  def elem(m, 2, 3), do: Kernel.elem(m.elements, 11)
  def elem(m, 3, 0), do: Kernel.elem(m.elements, 12)
  def elem(m, 3, 1), do: Kernel.elem(m.elements, 13)
  def elem(m, 3, 2), do: Kernel.elem(m.elements, 14)
  def elem(m, 3, 3), do: Kernel.elem(m.elements, 15)

  @doc """
  Returns an identity matrix.
  """
  @spec identity_matrix() :: t
  def identity_matrix do
    Matrix4x4.new(
      {1.0, 0.0, 0.0, 0.0},
      {0.0, 1.0, 0.0, 0.0},
      {0.0, 0.0, 1.0, 0.0},
      {0.0, 0.0, 0.0, 1.0}
    )
  end

  @doc """
  Computes the inverse of the matrix `m`.

  An `ArithmeticError` is raised if `m` cannot be inverted.
  """
  @spec inverse(t) :: t
  def inverse(m) do
    # Compute the 2x2 determinants of the matrix
    det1 = elem(m, 0, 0) * elem(m, 1, 1) - elem(m, 1, 0) * elem(m, 0, 1)
    det2 = elem(m, 0, 0) * elem(m, 1, 2) - elem(m, 0, 2) * elem(m, 1, 0)
    det3 = elem(m, 0, 0) * elem(m, 1, 3) - elem(m, 0, 3) * elem(m, 1, 0)
    det4 = elem(m, 0, 1) * elem(m, 1, 2) - elem(m, 0, 2) * elem(m, 1, 1)
    det5 = elem(m, 0, 1) * elem(m, 1, 3) - elem(m, 0, 3) * elem(m, 1, 1)
    det6 = elem(m, 0, 2) * elem(m, 1, 3) - elem(m, 0, 3) * elem(m, 1, 2)
    det7 = elem(m, 2, 0) * elem(m, 3, 1) - elem(m, 2, 1) * elem(m, 3, 0)
    det8 = elem(m, 2, 0) * elem(m, 3, 2) - elem(m, 2, 2) * elem(m, 3, 0)
    det9 = elem(m, 2, 0) * elem(m, 3, 3) - elem(m, 2, 3) * elem(m, 3, 0)
    det10 = elem(m, 2, 1) * elem(m, 3, 2) - elem(m, 2, 2) * elem(m, 3, 1)
    det11 = elem(m, 2, 1) * elem(m, 3, 3) - elem(m, 2, 3) * elem(m, 3, 1)
    det12 = elem(m, 2, 2) * elem(m, 3, 3) - elem(m, 3, 2) * elem(m, 2, 3)

    inverse_det =
      1 / (det1 * det12 - det2 * det11 + det3 * det10 + det4 * det9 - det5 * det8 + det6 * det7)

    # Compute the adjoint matrix
    Matrix4x4.new(
      (elem(m, 1, 1) * det12 - elem(m, 1, 2) * det11 + elem(m, 1, 3) * det10) * inverse_det,
      (elem(m, 0, 2) * det11 - elem(m, 0, 1) * det12 - elem(m, 0, 3) * det10) * inverse_det,
      (elem(m, 3, 1) * det6 - elem(m, 3, 2) * det5 + elem(m, 3, 3) * det4) * inverse_det,
      (elem(m, 2, 2) * det5 - elem(m, 2, 1) * det6 - elem(m, 2, 3) * det4) * inverse_det,
      (elem(m, 1, 2) * det9 - elem(m, 1, 0) * det12 - elem(m, 1, 3) * det8) * inverse_det,
      (elem(m, 0, 0) * det12 - elem(m, 0, 2) * det9 + elem(m, 0, 3) * det8) * inverse_det,
      (elem(m, 3, 2) * det3 - elem(m, 3, 0) * det6 - elem(m, 3, 3) * det2) * inverse_det,
      (elem(m, 2, 0) * det6 - elem(m, 2, 2) * det3 + elem(m, 2, 3) * det2) * inverse_det,
      (elem(m, 1, 0) * det11 - elem(m, 1, 1) * det9 + elem(m, 1, 3) * det7) * inverse_det,
      (elem(m, 0, 1) * det9 - elem(m, 0, 0) * det11 - elem(m, 0, 3) * det7) * inverse_det,
      (elem(m, 3, 0) * det5 - elem(m, 3, 1) * det3 + elem(m, 3, 3) * det1) * inverse_det,
      (elem(m, 2, 1) * det3 - elem(m, 2, 0) * det5 - elem(m, 2, 3) * det1) * inverse_det,
      (elem(m, 1, 1) * det8 - elem(m, 1, 0) * det10 - elem(m, 1, 2) * det7) * inverse_det,
      (elem(m, 0, 0) * det10 - elem(m, 0, 1) * det8 + elem(m, 0, 2) * det7) * inverse_det,
      (elem(m, 3, 1) * det2 - elem(m, 3, 0) * det4 - elem(m, 3, 2) * det1) * inverse_det,
      (elem(m, 2, 0) * det4 - elem(m, 2, 1) * det2 + elem(m, 2, 2) * det1) * inverse_det
    )
  end

  @doc """
  Multiplies two matrices and return the resulting matrix.
  """
  @spec multiply(t, t) :: t
  def multiply(m1, m2) do
    Matrix4x4.new(
      elem(m1, 0, 0) * elem(m2, 0, 0) + elem(m1, 0, 1) * elem(m2, 1, 0) +
        elem(m1, 0, 2) * elem(m2, 2, 0) + elem(m1, 0, 3) * elem(m2, 3, 0),
      elem(m1, 0, 0) * elem(m2, 0, 1) + elem(m1, 0, 1) * elem(m2, 1, 1) +
        elem(m1, 0, 2) * elem(m2, 2, 1) + elem(m1, 0, 3) * elem(m2, 3, 1),
      elem(m1, 0, 0) * elem(m2, 0, 2) + elem(m1, 0, 1) * elem(m2, 1, 2) +
        elem(m1, 0, 2) * elem(m2, 2, 2) + elem(m1, 0, 3) * elem(m2, 3, 2),
      elem(m1, 0, 0) * elem(m2, 0, 3) + elem(m1, 0, 1) * elem(m2, 1, 3) +
        elem(m1, 0, 2) * elem(m2, 2, 3) + elem(m1, 0, 3) * elem(m2, 3, 3),
      elem(m1, 1, 0) * elem(m2, 0, 0) + elem(m1, 1, 1) * elem(m2, 1, 0) +
        elem(m1, 1, 2) * elem(m2, 2, 0) + elem(m1, 1, 3) * elem(m2, 3, 0),
      elem(m1, 1, 0) * elem(m2, 0, 1) + elem(m1, 1, 1) * elem(m2, 1, 1) +
        elem(m1, 1, 2) * elem(m2, 2, 1) + elem(m1, 1, 3) * elem(m2, 3, 1),
      elem(m1, 1, 0) * elem(m2, 0, 2) + elem(m1, 1, 1) * elem(m2, 1, 2) +
        elem(m1, 1, 2) * elem(m2, 2, 2) + elem(m1, 1, 3) * elem(m2, 3, 2),
      elem(m1, 1, 0) * elem(m2, 0, 3) + elem(m1, 1, 1) * elem(m2, 1, 3) +
        elem(m1, 1, 2) * elem(m2, 2, 3) + elem(m1, 1, 3) * elem(m2, 3, 3),
      elem(m1, 2, 0) * elem(m2, 0, 0) + elem(m1, 2, 1) * elem(m2, 1, 0) +
        elem(m1, 2, 2) * elem(m2, 2, 0) + elem(m1, 2, 3) * elem(m2, 3, 0),
      elem(m1, 2, 0) * elem(m2, 0, 1) + elem(m1, 2, 1) * elem(m2, 1, 1) +
        elem(m1, 2, 2) * elem(m2, 2, 1) + elem(m1, 2, 3) * elem(m2, 3, 1),
      elem(m1, 2, 0) * elem(m2, 0, 2) + elem(m1, 2, 1) * elem(m2, 1, 2) +
        elem(m1, 2, 2) * elem(m2, 2, 2) + elem(m1, 2, 3) * elem(m2, 3, 2),
      elem(m1, 2, 0) * elem(m2, 0, 3) + elem(m1, 2, 1) * elem(m2, 1, 3) +
        elem(m1, 2, 2) * elem(m2, 2, 3) + elem(m1, 2, 3) * elem(m2, 3, 3),
      elem(m1, 3, 0) * elem(m2, 0, 0) + elem(m1, 3, 1) * elem(m2, 1, 0) +
        elem(m1, 3, 2) * elem(m2, 2, 0) + elem(m1, 3, 3) * elem(m2, 3, 0),
      elem(m1, 3, 0) * elem(m2, 0, 1) + elem(m1, 3, 1) * elem(m2, 1, 1) +
        elem(m1, 3, 2) * elem(m2, 2, 1) + elem(m1, 3, 3) * elem(m2, 3, 1),
      elem(m1, 3, 0) * elem(m2, 0, 2) + elem(m1, 3, 1) * elem(m2, 1, 2) +
        elem(m1, 3, 2) * elem(m2, 2, 2) + elem(m1, 3, 3) * elem(m2, 3, 2),
      elem(m1, 3, 0) * elem(m2, 0, 3) + elem(m1, 3, 1) * elem(m2, 1, 3) +
        elem(m1, 3, 2) * elem(m2, 2, 3) + elem(m1, 3, 3) * elem(m2, 3, 3)
    )
  end

  @doc """
  Creates a new matrix from the given individual element values.
  """
  @spec new(
          float,
          float,
          float,
          float,
          float,
          float,
          float,
          float,
          float,
          float,
          float,
          float,
          float,
          float,
          float,
          float
        ) :: t
  def new(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33) do
    %Matrix4x4{
      elements: {m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33}
    }
  end

  @doc """
  Creates a new matrix from the given row tuple values.
  """
  @spec new(
          {float, float, float, float},
          {float, float, float, float},
          {float, float, float, float},
          {float, float, float, float}
        ) :: t
  def new(row1, row2, row3, row4)

  def new({m00, m01, m02, m03}, {m10, m11, m12, m13}, {m20, m21, m22, m23}, {m30, m31, m32, m33}) do
    %Matrix4x4{
      elements: {m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33}
    }
  end

  @doc """
  Transposes the matrix `m` and returns the resulting matrix.
  """
  @spec transpose(t) :: t
  def transpose(m) do
    Matrix4x4.new(
      {elem(m, 0, 0), elem(m, 1, 0), elem(m, 2, 0), elem(m, 3, 0)},
      {elem(m, 0, 1), elem(m, 1, 1), elem(m, 2, 1), elem(m, 3, 1)},
      {elem(m, 0, 2), elem(m, 1, 2), elem(m, 2, 2), elem(m, 3, 2)},
      {elem(m, 0, 3), elem(m, 1, 3), elem(m, 2, 3), elem(m, 3, 3)}
    )
  end
end
