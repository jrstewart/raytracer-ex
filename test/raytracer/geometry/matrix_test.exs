defmodule Raytracer.Geometry.MatrixTest do
  use ExUnit.Case, async: true

  import Raytracer.MatrixTestHelpers

  alias Raytracer.Geometry.Matrix

  describe "Raytracer.Geometry.Matrix.elem/3" do
    test "returns the element at the give row and column indices" do
      m = { 1.0,  2.0,  3.0,  4.0,
            5.0,  6.0,  7.0,  8.0,
            9.0, 10.0, 11.0, 12.0,
           13.0, 14.0, 15.0, 16.0}

      assert Matrix.elem(m, 0, 0) == 1.0
      assert Matrix.elem(m, 0, 1) == 2.0
      assert Matrix.elem(m, 0, 2) == 3.0
      assert Matrix.elem(m, 0, 3) == 4.0
      assert Matrix.elem(m, 1, 0) == 5.0
      assert Matrix.elem(m, 1, 1) == 6.0
      assert Matrix.elem(m, 1, 2) == 7.0
      assert Matrix.elem(m, 1, 3) == 8.0
      assert Matrix.elem(m, 2, 0) == 9.0
      assert Matrix.elem(m, 2, 1) == 10.0
      assert Matrix.elem(m, 2, 2) == 11.0
      assert Matrix.elem(m, 2, 3) == 12.0
      assert Matrix.elem(m, 3, 0) == 13.0
      assert Matrix.elem(m, 3, 1) == 14.0
      assert Matrix.elem(m, 3, 2) == 15.0
      assert Matrix.elem(m, 3, 3) == 16.0
    end
  end

  describe "Raytracer.Geometry.Matrix.multiply/2" do
    test "multiplies two matrices and returns the resulting matrix" do
      m1 = { 1.0,  2.0,  3.0,  4.0,
             5.0,  6.0,  7.0,  8.0,
             9.0, 10.0, 11.0, 12.0,
            13.0, 14.0, 15.0, 16.0}
      m2 = { 5.0,  9.0, 13.0, 1.0,
             8.0, 12.0,  4.0, 8.0,
            11.0,  7.0,  2.0, 2.0,
             6.0, 10.0,  5.0, 3.0}
      expected = { 78.0,  94.0,  47.0,  35.0,
                  198.0, 246.0, 143.0,  91.0,
                  318.0, 398.0, 239.0, 147.0,
                  438.0, 550.0, 335.0, 203.0}

      assert Matrix.multiply(m1, m2) == expected
    end
  end

  describe "Raytracer.Geometry.Matrix.inverse/1" do
    test "computes the inverse of a matrix" do
      m = { 4.0, 5.0,  5.0, 13.0,
            4.0, 6.0,  1.0, 14.0,
            9.0, 7.0, 11.0, 15.0,
           10.0, 8.0, 12.0,  2.0}

      # Computing the inverse twice returns the original matrix
      result = m |> Matrix.inverse |> Matrix.inverse

      assert_matrices_equal_within_delta result, m
    end
  end

  describe "Raytracer.Geometry.Matrix.transpose/1" do
    test "transposes a matrix" do
      m = { 1.0,  2.0,  3.0,  4.0,
            5.0,  6.0,  7.0,  8.0,
            9.0, 10.0, 11.0, 12.0,
           13.0, 14.0, 15.0, 16.0}
      expected = {1.0, 5.0,  9.0, 13.0,
                  2.0, 6.0, 10.0, 14.0,
                  3.0, 7.0, 11.0, 15.0,
                  4.0, 8.0, 12.0, 16.0}

      assert Matrix.transpose(m) == expected
    end
  end
end
