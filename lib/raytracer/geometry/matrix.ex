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

  @compile {:inline, elem: 3, identity_matrix: 0}

  @identity_matrix {1.0, 0.0, 0.0, 0.0,
                    0.0, 1.0, 0.0, 0.0,
                    0.0, 0.0, 1.0, 0.0,
                    0.0, 0.0, 0.0, 1.0}

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
  Returns an identity matrix.
  """
  @spec identity_matrix() :: t
  def identity_matrix, do: @identity_matrix

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
    determinant1 = m00 * m11 - m10 * m01
    determinant2 = m00 * m12 - m02 * m10
    determinant3 = m00 * m13 - m03 * m10
    determinant4 = m01 * m12 - m02 * m11
    determinant5 = m01 * m13 - m03 * m11
    determinant6 = m02 * m13 - m03 * m12
    determinant7 = m20 * m31 - m21 * m30
    determinant8 = m20 * m32 - m22 * m30
    determinant9 = m20 * m33 - m23 * m30
    determinant10 = m21 * m32 - m22 * m31
    determinant11 = m21 * m33 - m23 * m31
    determinant12 = m22 * m33 - m32 * m23

    inverse_determinant =
      1.0 /
      (determinant1 * determinant12 -
       determinant2 * determinant11 +
       determinant3 * determinant10 +
       determinant4 * determinant9 -
       determinant5 * determinant8 +
       determinant6 * determinant7)

    # Compute the adjoint matrix
    {(m11 * determinant12 - m12 * determinant11 + m13 * determinant10) * inverse_determinant,
     (m02 * determinant11 - m01 * determinant12 - m03 * determinant10) * inverse_determinant,
     (m31 * determinant6 - m32 * determinant5 + m33 * determinant4) * inverse_determinant,
     (m22 * determinant5 - m21 * determinant6 - m23 * determinant4) * inverse_determinant,
     (m12 * determinant9 - m10 * determinant12 - m13 * determinant8) * inverse_determinant,
     (m00 * determinant12 - m02 * determinant9 + m03 * determinant8) * inverse_determinant,
     (m32 * determinant3 - m30 * determinant6 - m33 * determinant2) * inverse_determinant,
     (m20 * determinant6 - m22 * determinant3 + m23 * determinant2) * inverse_determinant,
     (m10 * determinant11 - m11 * determinant9 + m13 * determinant7) * inverse_determinant,
     (m01 * determinant9 - m00 * determinant11 - m03 * determinant7) * inverse_determinant,
     (m30 * determinant5 - m31 * determinant3 + m33 * determinant1) * inverse_determinant,
     (m21 * determinant3 - m20 * determinant5 - m23 * determinant1) * inverse_determinant,
     (m11 * determinant8 - m10 * determinant10 - m12 * determinant7) * inverse_determinant,
     (m00 * determinant10 - m01 * determinant8 + m02 * determinant7) * inverse_determinant,
     (m31 * determinant2 - m30 * determinant4 - m32 * determinant1) * inverse_determinant,
     (m20 * determinant4 - m21 * determinant2 + m22 * determinant1) * inverse_determinant}
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
