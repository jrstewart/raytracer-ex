defmodule Raytracer.Geometry.Matrix do
  @moduledoc """
  This module provides a set of functions for working with matrices represented
  by a tuple of matrix elements stored in row-major order.
  """

  @type matrix4x4_t :: {float, float, float, float,
                        float, float, float, float,
                        float, float, float, float,
                        float, float, float, float}
  @type t :: matrix4x4_t

  @compile {:inline, elem: 3}

  @doc """
  Returns the matrix element at the given row, column index.
  """
  @spec elem(t, integer, integer) :: float
  def elem(matrix, row, column)
  def elem(matrix, 0, 0), do: Kernel.elem(matrix, 0)
  def elem(matrix, 0, 1), do: Kernel.elem(matrix, 1)
  def elem(matrix, 0, 2), do: Kernel.elem(matrix, 2)
  def elem(matrix, 0, 3), do: Kernel.elem(matrix, 3)
  def elem(matrix, 1, 0), do: Kernel.elem(matrix, 4)
  def elem(matrix, 1, 1), do: Kernel.elem(matrix, 5)
  def elem(matrix, 1, 2), do: Kernel.elem(matrix, 6)
  def elem(matrix, 1, 3), do: Kernel.elem(matrix, 7)
  def elem(matrix, 2, 0), do: Kernel.elem(matrix, 8)
  def elem(matrix, 2, 1), do: Kernel.elem(matrix, 9)
  def elem(matrix, 2, 2), do: Kernel.elem(matrix, 10)
  def elem(matrix, 2, 3), do: Kernel.elem(matrix, 11)
  def elem(matrix, 3, 0), do: Kernel.elem(matrix, 12)
  def elem(matrix, 3, 1), do: Kernel.elem(matrix, 13)
  def elem(matrix, 3, 2), do: Kernel.elem(matrix, 14)
  def elem(matrix, 3, 3), do: Kernel.elem(matrix, 15)

  @doc """
  Multiplies two matrices and return the resulting matrix.
  """
  @spec multiply(t, t) :: t
  def multiply(matrix1, matrix2)
  def multiply({m1_00, m1_01, m1_02, m1_03,
                m1_10, m1_11, m1_12, m1_13,
                m1_20, m1_21, m1_22, m1_23,
                m1_30, m1_31, m1_32, m1_33},
               {m2_00, m2_01, m2_02, m2_03,
                m2_10, m2_11, m2_12, m2_13,
                m2_20, m2_21, m2_22, m2_23,
                m2_30, m2_31, m2_32, m2_33}) do
    {m1_00 * m2_00 + m1_01 * m2_10 + m1_02 * m2_20 + m1_03 * m2_30,
     m1_00 * m2_01 + m1_01 * m2_11 + m1_02 * m2_21 + m1_03 * m2_31,
     m1_00 * m2_02 + m1_01 * m2_12 + m1_02 * m2_22 + m1_03 * m2_32,
     m1_00 * m2_03 + m1_01 * m2_13 + m1_02 * m2_23 + m1_03 * m2_33,
     m1_10 * m2_00 + m1_11 * m2_10 + m1_12 * m2_20 + m1_13 * m2_30,
     m1_10 * m2_01 + m1_11 * m2_11 + m1_12 * m2_21 + m1_13 * m2_31,
     m1_10 * m2_02 + m1_11 * m2_12 + m1_12 * m2_22 + m1_13 * m2_32,
     m1_10 * m2_03 + m1_11 * m2_13 + m1_12 * m2_23 + m1_13 * m2_33,
     m1_20 * m2_00 + m1_21 * m2_10 + m1_22 * m2_20 + m1_23 * m2_30,
     m1_20 * m2_01 + m1_21 * m2_11 + m1_22 * m2_21 + m1_23 * m2_31,
     m1_20 * m2_02 + m1_21 * m2_12 + m1_22 * m2_22 + m1_23 * m2_32,
     m1_20 * m2_03 + m1_21 * m2_13 + m1_22 * m2_23 + m1_23 * m2_33,
     m1_30 * m2_00 + m1_31 * m2_10 + m1_32 * m2_20 + m1_33 * m2_30,
     m1_30 * m2_01 + m1_31 * m2_11 + m1_32 * m2_21 + m1_33 * m2_31,
     m1_30 * m2_02 + m1_31 * m2_12 + m1_32 * m2_22 + m1_33 * m2_32,
     m1_30 * m2_03 + m1_31 * m2_13 + m1_32 * m2_23 + m1_33 * m2_33}
  end

  @doc """
  Computes the inverse of `matrix`.

  An `ArithmeticError` is raised if `matrix` cannot be inverted.
  """
  @spec inverse(t) :: t
  def inverse(matrix)
  def inverse({m00, m01, m02, m03,
               m10, m11, m12, m13,
               m20, m21, m22, m23,
               m30, m31, m32, m33}) do
    # Compute the 2x2 determinants of the matrix
    det1 = m00 * m11 - m10 * m01
    det2 = m00 * m12 - m02 * m10
    det3 = m00 * m13 - m03 * m10
    det4 = m01 * m12 - m02 * m11
    det5 = m01 * m13 - m03 * m11
    det6 = m02 * m13 - m03 * m12
    det7 = m20 * m31 - m21 * m30
    det8 = m20 * m32 - m22 * m30
    det9 = m20 * m33 - m23 * m30
    det10 = m21 * m32 - m22 * m31
    det11 = m21 * m33 - m23 * m31
    det12 = m22 * m33 - m32 * m23

    # Compute the determinant of the matrix
    det = det1 * det12 - det2 * det11 + det3 * det10 + det4 * det9 - det5 * det8 + det6 * det7
    inverse_det = 1.0 / det

    # Compute the adjoint matrix
    {(m11 * det12 - m12 * det11 + m13 * det10) * inverse_det,
     (m02 * det11 - m01 * det12 - m03 * det10) * inverse_det,
     (m31 * det6 - m32 * det5 + m33 * det4) * inverse_det,
     (m22 * det5 - m21 * det6 - m23 * det4) * inverse_det,
     (m12 * det9 - m10 * det12 - m13 * det8) * inverse_det,
     (m00 * det12 - m02 * det9 + m03 * det8) * inverse_det,
     (m32 * det3 - m30 * det6 - m33 * det2) * inverse_det,
     (m20 * det6 - m22 * det3 + m23 * det2) * inverse_det,
     (m10 * det11 - m11 * det9 + m13 * det7) * inverse_det,
     (m01 * det9 - m00 * det11 - m03 * det7) * inverse_det,
     (m30 * det5 - m31 * det3 + m33 * det1) * inverse_det,
     (m21 * det3 - m20 * det5 - m23 * det1) * inverse_det,
     (m11 * det8 - m10 * det10 - m12 * det7) * inverse_det,
     (m00 * det10 - m01 * det8 + m02 * det7) * inverse_det,
     (m31 * det2 - m30 * det4 - m32 * det1) * inverse_det,
     (m20 * det4 - m21 * det2 + m22 * det1) * inverse_det}
  end

  @doc """
  Transposes `matrix` and returns the resulting matrix.
  """
  @spec transpose(t) :: t
  def transpose(matrix)
  def transpose({m00, m01, m02, m03,
                 m10, m11, m12, m13,
                 m20, m21, m22, m23,
                 m30, m31, m32, m33}) do
    {m00, m10, m20, m30,
     m01, m11, m21, m31,
     m02, m12, m22, m32,
     m03, m13, m23, m33}
  end
end
