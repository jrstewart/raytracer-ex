defmodule Raytracer.Geometry.Matrix4x4Test do
  use ExUnit.Case, async: true

  import Raytracer.GeometryTestHelpers

  alias Raytracer.Geometry.Matrix4x4

  describe "Raytracer.Geometry.Matrix4x4.diagonal_matrix/4" do
    test "returns a diagonal matrix with the given elements" do
      matrix =
        Matrix4x4.new(
          {1.0, 0.0, 0.0, 0.0},
          {0.0, 2.0, 0.0, 0.0},
          {0.0, 0.0, 3.0, 0.0},
          {0.0, 0.0, 0.0, 4.0}
        )

      assert Matrix4x4.diagonal_matrix(1.0, 2.0, 3.0, 4.0) == matrix
    end
  end

  describe "Raytracer.Geometry.Matrix4x4.elem/3" do
    test "returns the element at the give row and column indices" do
      matrix =
        Matrix4x4.new(
          {1.0, 2.0, 3.0, 4.0},
          {5.0, 6.0, 7.0, 8.0},
          {9.0, 10.0, 11.0, 12.0},
          {13.0, 14.0, 15.0, 16.0}
        )

      assert Matrix4x4.elem(matrix, 0, 0) == 1.0
      assert Matrix4x4.elem(matrix, 0, 1) == 2.0
      assert Matrix4x4.elem(matrix, 0, 2) == 3.0
      assert Matrix4x4.elem(matrix, 0, 3) == 4.0
      assert Matrix4x4.elem(matrix, 1, 0) == 5.0
      assert Matrix4x4.elem(matrix, 1, 1) == 6.0
      assert Matrix4x4.elem(matrix, 1, 2) == 7.0
      assert Matrix4x4.elem(matrix, 1, 3) == 8.0
      assert Matrix4x4.elem(matrix, 2, 0) == 9.0
      assert Matrix4x4.elem(matrix, 2, 1) == 10.0
      assert Matrix4x4.elem(matrix, 2, 2) == 11.0
      assert Matrix4x4.elem(matrix, 2, 3) == 12.0
      assert Matrix4x4.elem(matrix, 3, 0) == 13.0
      assert Matrix4x4.elem(matrix, 3, 1) == 14.0
      assert Matrix4x4.elem(matrix, 3, 2) == 15.0
      assert Matrix4x4.elem(matrix, 3, 3) == 16.0
    end
  end

  describe "Raytracer.Geometry.Matrix4x4.identity_matrix/0" do
    test "returns the identity matrix" do
      expected =
        Matrix4x4.new(
          {1.0, 0.0, 0.0, 0.0},
          {0.0, 1.0, 0.0, 0.0},
          {0.0, 0.0, 1.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      assert Matrix4x4.identity_matrix() == expected
    end
  end

  describe "Raytracer.Geometry.Matrix4x4.multiply/2" do
    test "multiplies two matrices and returns the resulting matrix" do
      matrix1 =
        Matrix4x4.new(
          {1.0, 2.0, 3.0, 4.0},
          {5.0, 6.0, 7.0, 8.0},
          {9.0, 10.0, 11.0, 12.0},
          {13.0, 14.0, 15.0, 16.0}
        )

      matrix2 =
        Matrix4x4.new(
          {5.0, 9.0, 13.0, 1.0},
          {8.0, 12.0, 4.0, 8.0},
          {11.0, 7.0, 2.0, 2.0},
          {6.0, 10.0, 5.0, 3.0}
        )

      expected =
        Matrix4x4.new(
          {78.0, 94.0, 47.0, 35.0},
          {198.0, 246.0, 143.0, 91.0},
          {318.0, 398.0, 239.0, 147.0},
          {438.0, 550.0, 335.0, 203.0}
        )

      assert Matrix4x4.multiply(matrix1, matrix2) == expected
    end
  end

  describe "Raytracer.Geometry.Matrix4x4.inverse/1" do
    test "computes the inverse of a matrix" do
      matrix =
        Matrix4x4.new(
          {4.0, 5.0, 5.0, 13.0},
          {4.0, 6.0, 1.0, 14.0},
          {9.0, 7.0, 11.0, 15.0},
          {10.0, 8.0, 12.0, 2.0}
        )

      # Computing the inverse twice returns the original matrix
      result = matrix |> Matrix4x4.inverse() |> Matrix4x4.inverse()

      assert_equal_within_delta(result, matrix)
    end
  end

  describe "Raytracer.Geometry.Matrix4x4.transpose/1" do
    test "transposes a matrix" do
      matrix =
        Matrix4x4.new(
          {1.0, 2.0, 3.0, 4.0},
          {5.0, 6.0, 7.0, 8.0},
          {9.0, 10.0, 11.0, 12.0},
          {13.0, 14.0, 15.0, 16.0}
        )

      expected =
        Matrix4x4.new(
          {1.0, 5.0, 9.0, 13.0},
          {2.0, 6.0, 10.0, 14.0},
          {3.0, 7.0, 11.0, 15.0},
          {4.0, 8.0, 12.0, 16.0}
        )

      assert Matrix4x4.transpose(matrix) == expected
    end
  end
end
