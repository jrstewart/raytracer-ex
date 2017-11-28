defmodule Raytracer.Geometry.QuaternionTest do
  use ExUnit.Case, async: true

  import Raytracer.GeometryTestHelpers

  alias Raytracer.Transform
  alias Raytracer.Geometry.{Matrix4x4, Quaternion}

  describe "Raytracer.Geometry.Quaternion.add/2" do
    test "adds two quaternions" do
      quaternion1 = %Quaternion{x: 1.0, y: 2.0, z: 3.0, w: 4.0}
      quaternion2 = %Quaternion{x: 5.0, y: 6.0, z: 7.0, w: 8.0}
      expected = %Quaternion{x: 6.0, y: 8.0, z: 10.0, w: 12.0}

      assert Quaternion.add(quaternion1, quaternion2) == expected
    end
  end

  describe "Raytracer.Geometry.Quaternion.divide/2" do
    test "divides a quaternion by a scalar value" do
      quaternion = %Quaternion{x: 2.0, y: 4.0, z: 6.0, w: 8.0}
      expected = %Quaternion{x: 1.0, y: 2.0, z: 3.0, w: 4.0}

      assert Quaternion.divide(quaternion, 2.0) == expected
    end
  end

  describe "Raytracer.Geometry.Quaternion.dot/2" do
    test "computes the dot product of two quaternions" do
      quaternion1 = %Quaternion{x: 1.0, y: 1.0, z: 1.0, w: 1.0}
      quaternion2 = %Quaternion{x: 2.0, y: 2.0, z: 2.0, w: 2.0}

      assert Quaternion.dot(quaternion1, quaternion2) == 8.0
    end
  end

  describe "Raytracer.Geometry.Quaternion.from_matrix/1" do
    test "creates a quaternion when the trace matrix is positive" do
      matrix =
        Matrix4x4.new(
          {1.0, 0.0, 0.0, 0.0},
          {0.0, 1.0, 0.0, 0.0},
          {0.0, 0.0, 1.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      expected = %Quaternion{x: 0.0, y: 0.0, z: 0.0, w: 1.0}

      assert_equal_within_delta(Quaternion.from_matrix(matrix), expected)
    end

    test "creates a quaternion when the m00 element is the largest trace element and trace matrix is non-positive" do
      matrix =
        Matrix4x4.new(
          {-2.0, 2.0, 0.0, 0.0},
          {2.0, -3.0, 1.0, 0.0},
          {0.0, 1.0, -3.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      expected = %Quaternion{x: 1.118034, y: 0.8944272, z: 0.0, w: 0.0}

      assert_equal_within_delta(Quaternion.from_matrix(matrix), expected)
    end

    test "creates a quaternion when the m11 element is the largest trace element and trace matrix is non-positive" do
      matrix =
        Matrix4x4.new(
          {-3.0, 2.0, 0.0, 0.0},
          {2.0, -2.0, 1.0, 0.0},
          {0.0, 1.0, -3.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      expected = %Quaternion{x: 0.8944272, y: 1.118034, z: 0.4472136, w: 0.0}

      assert_equal_within_delta(Quaternion.from_matrix(matrix), expected)
    end

    test "creates a quaternion when the m22 element is the largest trace element and trace matrix is non-positive" do
      matrix =
        Matrix4x4.new(
          {-3.0, 2.0, 0.0, 0.0},
          {2.0, -3.0, 1.0, 0.0},
          {0.0, 1.0, -2.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      expected = %Quaternion{x: 0.0, y: 0.4472136, z: 1.118034, w: 0.0}

      assert_equal_within_delta(Quaternion.from_matrix(matrix), expected)
    end
  end

  describe "Raytracer.Geometry.Quaternion.from_transform/1" do
    test "creates a quaternion when the trace matrix of the transform is positive" do
      transform = Matrix4x4.identity_matrix() |> Transform.from_matrix()
      expected = %Quaternion{x: 0.0, y: 0.0, z: 0.0, w: 1.0}

      assert_equal_within_delta(Quaternion.from_transform(transform), expected)
    end
  end

  describe "Raytracer.Geometry.Quaternion.length/1" do
    test "computes the length of a quaternion" do
      quaternion = %Quaternion{x: 2.0, y: 2.0, z: 2.0, w: 2.0}

      assert Quaternion.length(quaternion) == 4.0
    end
  end

  describe "Raytracer.Geometry.Quaternion.multiply/2" do
    test "multiplies a quaternion by a scalar value" do
      quaternion = %Quaternion{x: 2.0, y: 4.0, z: 6.0, w: 8.0}
      expected = %Quaternion{x: 4.0, y: 8.0, z: 12.0, w: 16.0}

      assert Quaternion.multiply(quaternion, 2.0) == expected
    end
  end

  describe "Raytracer.Geometry.Quaternion.normalize/1" do
    test "normalizes a quaternion" do
      quaternion = %Quaternion{x: 10.0, y: 10.0, z: 10.0, w: 10.0}
      expected = %Quaternion{x: 0.5, y: 0.5, z: 0.5, w: 0.5}

      assert Quaternion.normalize(quaternion) == expected
    end
  end

  describe "Raytracer.Geometry.Quaternion.slerp/3" do
    test "computes the spherical linear interpolates between two quaternions" do
      quaternion1 = %Quaternion{x: 1.0, y: 1.0, z: 0.0, w: 1.0}
      quaternion2 = %Quaternion{x: -1.0, y: -1.0, z: 0.0, w: 1.0}
      expected = %Quaternion{x: 0.0, y: 0.0, z: 0.0, w: 2.0}

      assert_equal_within_delta(Quaternion.slerp(quaternion1, quaternion2, 0.5), expected)

      quaternion1 = %Quaternion{x: 2.0, y: 0.0, z: 0.0, w: 1.0}
      quaternion2 = %Quaternion{x: 0.0, y: 2.0, z: 0.0, w: 1.0}
      expected = %Quaternion{x: 0.5773503, y: 0.5773503, z: 0.0, w: 0.5773503}

      assert_equal_within_delta(Quaternion.slerp(quaternion1, quaternion2, 0.5), expected)
    end
  end

  describe "Raytracer.Geometry.Quaternion.subtract/2" do
    test "subtracts two quaternions" do
      quaternion1 = %Quaternion{x: 5.0, y: 6.0, z: 7.0, w: 8.0}
      quaternion2 = %Quaternion{x: 1.0, y: 2.0, z: 3.0, w: 4.0}
      expected = %Quaternion{x: 4.0, y: 4.0, z: 4.0, w: 4.0}

      assert Quaternion.subtract(quaternion1, quaternion2) == expected
    end
  end

  describe "Raytracer.Geometry.Quaternion.to_transform/1" do
    test "converts a quaternion into a transform" do
      quaternion = %Quaternion{x: 1.0, y: 2.0, z: 3.0, w: 4.0}

      matrix =
        Matrix4x4.new(
          {-25.0, -20.0, 22.0, 0.0},
          {28.0, -19.0, 4.0, 0.0},
          {-10.0, 20.0, -9.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      expected = %Transform{matrix: matrix, inverse_matrix: Matrix4x4.transpose(matrix)}

      assert Quaternion.to_transform(quaternion) == expected
    end
  end
end
