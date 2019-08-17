defmodule Raytracer.TransformTest do
  use ExUnit.Case, async: true
  import Raytracer.GeometryTestHelpers
  alias Raytracer.Transform
  alias Raytracer.Geometry.{Matrix4x4, Point3, Vector3}

  describe "Raytracer.Transform.from_matrix/1" do
    test "creates a transform from a matrix" do
      matrix =
        Matrix4x4.new(
          {1.0, 0.0, 0.0, 1.0},
          {0.0, 1.0, 0.0, 1.0},
          {0.0, 0.0, 1.0, 1.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      transform = Transform.from_matrix(matrix)

      assert transform.matrix == matrix
      assert transform.inverse_matrix == Matrix4x4.inverse(matrix)
    end
  end

  describe "Raytracer.Transform.has_scale?/1" do
    test "returns true if the transform is a scaling transform" do
      transform = Transform.scale(2.0, 3.0, 4.0)

      assert Transform.has_scale?(transform)
    end

    test "returns false if the transform is not a scaling transform" do
      transform = Transform.translate(2.0, 3.0, 4.0)

      refute Transform.has_scale?(transform)
    end
  end

  describe "Raytracer.Transform.inverse/1" do
    test "computes the inverse of a transform" do
      transform =
        Transform.from_matrix(
          Matrix4x4.new(
            {1.0, 0.0, 0.0, 1.0},
            {0.0, 1.0, 0.0, 1.0},
            {0.0, 0.0, 1.0, 1.0},
            {0.0, 0.0, 0.0, 1.0}
          )
        )

      inverse = Transform.inverse(transform)

      assert inverse.matrix == transform.inverse_matrix
      assert inverse.inverse_matrix == transform.matrix
    end
  end

  describe "Raytracer.Transform.look_at/3" do
    test "creates a look at transform" do
      position = %Point3{x: 0.0, y: 0.0, z: 0.0}
      center = %Point3{x: 0.0, y: 0.0, z: -10.0}
      up = %Vector3{dx: 0.0, dy: 1.0, dz: 0.0}

      expected =
        Matrix4x4.new(
          {-1.0, 0.0, 0.0, 0.0},
          {0.0, 1.0, 0.0, 0.0},
          {0.0, 0.0, -1.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      transform = Transform.look_at(position, center, up)

      assert_equal_within_delta(transform.matrix, expected)
      assert_equal_within_delta(transform.inverse_matrix, Matrix4x4.inverse(expected))
    end
  end

  describe "Raytracer.Transform.multiply/2" do
    test "multiplies two transforms and returns the resulting transform" do
      transform1 = Transform.scale(2.0, 3.0, 4.0)
      transform2 = Transform.translate(2.0, 3.0, 4.0)

      expected =
        Transform.from_matrix(
          Matrix4x4.new(
            {2.0, 0.0, 0.0, 4.0},
            {0.0, 3.0, 0.0, 9.0},
            {0.0, 0.0, 4.0, 16.0},
            {0.0, 0.0, 0.0, 1.0}
          )
        )

      assert Transform.multiply(transform1, transform2) == expected
    end
  end

  describe "Raytracer.Transform.rotate/2" do
    test "creates a rotation transform about the x-axis" do
      expected =
        Matrix4x4.new(
          {1.0, 0.0, 0.0, 0.0},
          {0.0, 0.0, -1.0, 0.0},
          {0.0, 1.0, 0.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      axis = %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}

      transform = Transform.rotate(90.0, axis)

      assert_equal_within_delta(transform.matrix, expected)
      assert_equal_within_delta(transform.inverse_matrix, Matrix4x4.inverse(expected))
    end

    test "creates a rotation transform about the y-axis" do
      expected =
        Matrix4x4.new(
          {0.0, 0.0, 1.0, 0.0},
          {0.0, 1.0, 0.0, 0.0},
          {-1.0, 0.0, 0.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      axis = %Vector3{dx: 0.0, dy: 1.0, dz: 0.0}

      transform = Transform.rotate(90.0, axis)

      assert_equal_within_delta(transform.matrix, expected)
      assert_equal_within_delta(transform.inverse_matrix, Matrix4x4.inverse(expected))
    end

    test "creates a rotation transform about the z-axis" do
      expected =
        Matrix4x4.new(
          {0.0, -1.0, 0.0, 0.0},
          {1.0, 0.0, 0.0, 0.0},
          {0.0, 0.0, 1.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      axis = %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}

      transform = Transform.rotate(90.0, axis)

      assert_equal_within_delta(transform.matrix, expected)
      assert_equal_within_delta(transform.inverse_matrix, Matrix4x4.inverse(expected))
    end
  end

  describe "Raytracer.Transform.rotate_x/1" do
    test "creates a rotation transform about the x-axis" do
      expected =
        Matrix4x4.new(
          {1.0, 0.0, 0.0, 0.0},
          {0.0, 0.0, -1.0, 0.0},
          {0.0, 1.0, 0.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      transform = Transform.rotate_x(90.0)

      assert_equal_within_delta(transform.matrix, expected)
      assert_equal_within_delta(transform.inverse_matrix, Matrix4x4.inverse(expected))
    end
  end

  describe "Raytracer.Transform.rotate_y/1" do
    test "creates a rotation transform about the y-axis" do
      expected =
        Matrix4x4.new(
          {0.0, 0.0, 1.0, 0.0},
          {0.0, 1.0, 0.0, 0.0},
          {-1.0, 0.0, 0.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      transform = Transform.rotate_y(90.0)

      assert_equal_within_delta(transform.matrix, expected)
      assert_equal_within_delta(transform.inverse_matrix, Matrix4x4.inverse(expected))
    end
  end

  describe "Raytracer.Transform.rotate_z/1" do
    test "creates a rotation transform about the z-axis" do
      expected =
        Matrix4x4.new(
          {0.0, -1.0, 0.0, 0.0},
          {1.0, 0.0, 0.0, 0.0},
          {0.0, 0.0, 1.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      transform = Transform.rotate_z(90.0)

      assert_equal_within_delta(transform.matrix, expected)
      assert_equal_within_delta(transform.inverse_matrix, Matrix4x4.inverse(expected))
    end
  end

  describe "Raytracer.Transform.scale/1" do
    test "creates a scaling transform with the given scale factors" do
      expected =
        Matrix4x4.new(
          {2.0, 0.0, 0.0, 0.0},
          {0.0, 3.0, 0.0, 0.0},
          {0.0, 0.0, 4.0, 0.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      transform = Transform.scale(2.0, 3.0, 4.0)

      assert_equal_within_delta(transform.matrix, expected)
      assert_equal_within_delta(transform.inverse_matrix, Matrix4x4.inverse(expected))
    end
  end

  describe "Raytracer.Transform.swaps_handedness?/1" do
    test "returns true if the transform changes the coordinate system handedness" do
      transform =
        Transform.from_matrix(
          Matrix4x4.new(
            {1.0, 0.0, 0.0, 0.0},
            {0.0, 0.0, 1.0, 0.0},
            {0.0, 1.0, 0.0, 0.0},
            {0.0, 0.0, 0.0, 1.0}
          )
        )

      assert Transform.swaps_handedness?(transform)
    end

    test "returns false if the transform does not change the coordinate system handedness" do
      transform = Transform.scale(2.0, 3.0, 4.0)

      refute Transform.swaps_handedness?(transform)
    end
  end

  describe "Raytracer.Transform.translate/1" do
    test "creates a translation transform with the given deltas" do
      expected =
        Matrix4x4.new(
          {1.0, 0.0, 0.0, 2.0},
          {0.0, 1.0, 0.0, 3.0},
          {0.0, 0.0, 1.0, 4.0},
          {0.0, 0.0, 0.0, 1.0}
        )

      transform = Transform.translate(2.0, 3.0, 4.0)

      assert transform.matrix == expected
      assert transform.inverse_matrix == Matrix4x4.inverse(expected)
    end
  end

  describe "Raytracer.Transform.transpose/1" do
    test "transposes the matrix of a transformation" do
      transform = %Transform{
        matrix:
          Matrix4x4.new(
            {1.0, 0.0, 0.0, 1.0},
            {0.0, 1.0, 0.0, 1.0},
            {0.0, 0.0, 1.0, 1.0},
            {0.0, 0.0, 0.0, 1.0}
          ),
        inverse_matrix:
          Matrix4x4.new(
            {1.0, 0.0, 0.0, -1.0},
            {0.0, 1.0, 0.0, -1.0},
            {0.0, 0.0, 1.0, -1.0},
            {0.0, 0.0, 0.0, 1.0}
          )
      }

      transpose = Transform.transpose(transform)

      assert transpose.matrix == Matrix4x4.transpose(transform.matrix)
      assert transpose.inverse_matrix == Matrix4x4.transpose(transform.inverse_matrix)
    end
  end
end
