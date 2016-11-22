defmodule Raytracer.Geometry.Matrix4x4Test do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.Matrix4x4

  describe "Raytracer.Geometry.Matrix4x4.multiply/2" do
    test "multiplies two matrices and returns the resulting matrix" do
      m1 = %Matrix4x4{
        elements: {
          1.0,  2.0,  3.0,  4.0,
          5.0,  6.0,  7.0,  8.0,
          9.0,  10.0, 11.0, 12.0,
          13.0, 14.0, 15.0, 16.0,
        }
      }
      m2 = %Matrix4x4{
        elements: {
          5.0,  9.0,  13.0, 1.0,
          8.0,  12.0, 4.0,  8.0,
          11.0, 7.0,  2.0,  2.0,
          6.0,  10.0, 5.0,  3.0,
        }
      }
      expected = %Matrix4x4{
        elements: {
          78.0,  94.0,  47.0,  35.0,
          198.0, 246.0, 143.0, 91.0,
          318.0, 398.0, 239.0, 147.0,
          438.0, 550.0, 335.0, 203.0,
        }
      }

      assert Matrix4x4.multiply(m1, m2) == expected
    end
  end

  describe "Raytracer.Geometry.Matrix4x4.inverse/1" do
    test "computes the inverse of a matrix" do
      m = %Matrix4x4{
        elements: {
          4.0, 5.0, 5.0, 13.0,
          4.0, 6.0, 1.0, 14.0,
          9.0, 7.0, 11.0, 15.0,
          10.0, 8.0, 12.0, 2.0,
        }
      }
      delta = 0.0000001

      # Computing the inverse twice returns the original matrix
      result = m |> Matrix4x4.inverse |> Matrix4x4.inverse

      for i <- 0..15 do
        assert_in_delta elem(result.elements, i), elem(m.elements, i), delta
      end
    end
  end

  describe "Raytracer.Geometry.Matrix4x4.transpose/1" do
    test "transposes a matrix" do
      m = %Matrix4x4{
        elements: {
          1.0,  2.0,  3.0,  4.0,
          5.0,  6.0,  7.0,  8.0,
          9.0,  10.0, 11.0, 12.0,
          13.0, 14.0, 15.0, 16.0,
        }
      }
      expected = %Matrix4x4{
        elements: {
          1.0, 5.0, 9.0,  13.0,
          2.0, 6.0, 10.0, 14.0,
          3.0, 7.0, 11.0, 15.0,
          4.0, 8.0, 12.0, 16.0,
        }
      }

      assert Matrix4x4.transpose(m) == expected
    end
  end
end
