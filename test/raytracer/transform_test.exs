defmodule Raytracer.TransformTest do
  use ExUnit.Case, async: true

  import Raytracer.GeometryTestHelpers

  alias Raytracer.Geometry.Matrix
  alias Raytracer.Transform

  describe "Raytracer.Transform.from_matrix/1" do
    test "creates a transform from a matrix" do
      m = {1.0, 0.0, 0.0, 1.0,
           0.0, 1.0, 0.0, 1.0,
           0.0, 0.0, 1.0, 1.0,
           0.0, 0.0, 0.0, 1.0}

      t = Transform.from_matrix(m)

      assert t.matrix == m
      assert t.inverse_matrix == Matrix.inverse(m)
    end
  end

  describe "Raytracer.Transform.has_scale?/1" do
    test "returns true if the transform is a scaling transform" do
      t = Transform.scale({2.0, 3.0, 4.0})

      assert Transform.has_scale?(t)
    end

    test "returns false if the transform is not a scaling transform" do
      t = Transform.translate({2.0, 3.0, 4.0})

      refute Transform.has_scale?(t)
    end
  end

  describe "Raytracer.Transform.inverse/1" do
    test "computes the inverse of a transform" do
      t = Transform.from_matrix({1.0, 0.0, 0.0, 1.0,
                                 0.0, 1.0, 0.0, 1.0,
                                 0.0, 0.0, 1.0, 1.0,
                                 0.0, 0.0, 0.0, 1.0})

      inverse_t = Transform.inverse(t)

      assert inverse_t.matrix == t.inverse_matrix
      assert inverse_t.inverse_matrix == t.matrix
    end
  end

  describe "Raytracer.Transform.look_at/3" do
    test "creates a look at transform" do
      position = {0.0, 0.0, 0.0}
      center = {0.0, 0.0, -10.0}
      up = {0.0, 1.0, 0.0}
      expected = {-1.0, 0.0,  0.0, 0.0,
                   0.0, 1.0,  0.0, 0.0,
                   0.0, 0.0, -1.0, 0.0,
                   0.0, 0.0,  0.0, 1.0}

      t = Transform.look_at(position, center, up)

      assert_equal_within_delta t.matrix, expected
      assert_equal_within_delta t.inverse_matrix, Matrix.inverse(expected)
    end
  end

  describe "Raytracer.Transform.multiply/2" do
    test "multiplies two transforms and returns the resulting transform" do
      t1 = Transform.scale({2.0, 3.0, 4.0})
      t2 = Transform.translate({2.0, 3.0, 4.0})
      expected = Transform.from_matrix({2.0, 0.0, 0.0,  4.0,
                                        0.0, 3.0, 0.0,  9.0,
                                        0.0, 0.0, 4.0, 16.0,
                                        0.0, 0.0, 0.0,  1.0})

      assert Transform.multiply(t1, t2) == expected
    end
  end

  describe "Raytracer.Transform.rotate/2" do
    test "creates a rotation transform about the x-axis" do
      expected = {1.0, 0.0,  0.0, 0.0,
                  0.0, 0.0, -1.0, 0.0,
                  0.0, 1.0,  0.0, 0.0,
                  0.0, 0.0,  0.0, 1.0}

      t = Transform.rotate(90.0, {1.0, 0.0, 0.0})

      assert_equal_within_delta t.matrix, expected
      assert_equal_within_delta t.inverse_matrix, Matrix.inverse(expected)
    end

    test "creates a rotation transform about the y-axis" do
      expected = { 0.0, 0.0, 1.0, 0.0,
                   0.0, 1.0, 0.0, 0.0,
                  -1.0, 0.0, 0.0, 0.0,
                   0.0, 0.0, 0.0, 1.0}

      t = Transform.rotate(90.0, {0.0, 1.0, 0.0})

      assert_equal_within_delta t.matrix, expected
      assert_equal_within_delta t.inverse_matrix, Matrix.inverse(expected)
    end

    test "creates a rotation transform about the z-axis" do
      expected = {0.0, -1.0, 0.0, 0.0,
                  1.0,  0.0, 0.0, 0.0,
                  0.0,  0.0, 1.0, 0.0,
                  0.0,  0.0, 0.0, 1.0}

      t = Transform.rotate(90.0, {0.0, 0.0, 1.0})

      assert_equal_within_delta t.matrix, expected
      assert_equal_within_delta t.inverse_matrix, Matrix.inverse(expected)
    end
  end

  describe "Raytracer.Transform.rotate_x/1" do
    test "creates a rotation transform about the x-axis" do
      expected = {1.0, 0.0,  0.0, 0.0,
                  0.0, 0.0, -1.0, 0.0,
                  0.0, 1.0,  0.0, 0.0,
                  0.0, 0.0,  0.0, 1.0}

      t = Transform.rotate_x(90.0)

      assert_equal_within_delta t.matrix, expected
      assert_equal_within_delta t.inverse_matrix, Matrix.inverse(expected)
    end
  end

  describe "Raytracer.Transform.rotate_y/1" do
    test "creates a rotation transform about the y-axis" do
      expected = { 0.0, 0.0, 1.0, 0.0,
                   0.0, 1.0, 0.0, 0.0,
                  -1.0, 0.0, 0.0, 0.0,
                   0.0, 0.0, 0.0, 1.0}

      t = Transform.rotate_y(90.0)

      assert_equal_within_delta t.matrix, expected
      assert_equal_within_delta t.inverse_matrix, Matrix.inverse(expected)
    end
  end

  describe "Raytracer.Transform.rotate_z/1" do
    test "creates a rotation transform about the z-axis" do
      expected = {0.0, -1.0, 0.0, 0.0,
                  1.0,  0.0, 0.0, 0.0,
                  0.0,  0.0, 1.0, 0.0,
                  0.0,  0.0, 0.0, 1.0}

      t = Transform.rotate_z(90.0)

      assert_equal_within_delta t.matrix, expected
      assert_equal_within_delta t.inverse_matrix, Matrix.inverse(expected)
    end
  end

  describe "Raytracer.Transform.scale/1" do
    test "creates a scaling transform with the given scale factors" do
      expected = {2.0, 0.0, 0.0, 0.0,
                  0.0, 3.0, 0.0, 0.0,
                  0.0, 0.0, 4.0, 0.0,
                  0.0, 0.0, 0.0, 1.0}

      t = Transform.scale({2.0, 3.0, 4.0})

      assert t.matrix == expected
      assert t.inverse_matrix == Matrix.inverse(expected)
    end
  end

  describe "Raytracer.Transform.swaps_handedness?/1" do
    test "returns true if the transform changes the coordinate system handedness" do
      t = Transform.from_matrix({1.0, 0.0, 0.0, 0.0,
                                 0.0, 0.0, 1.0, 0.0,
                                 0.0, 1.0, 0.0, 0.0,
                                 0.0, 0.0, 0.0, 1.0})

      assert Transform.swaps_handedness?(t) == true
    end

    test "returns false if the transform does not change the coordinate system handedness" do
      t = Transform.scale({2.0, 3.0, 4.0})

      assert Transform.swaps_handedness?(t) == false
    end
  end

  describe "Raytracer.Transform.translate/1" do
    test "creates a translation transform with the given deltas" do
      expected = {1.0, 0.0, 0.0, 2.0,
                  0.0, 1.0, 0.0, 3.0,
                  0.0, 0.0, 1.0, 4.0,
                  0.0, 0.0, 0.0, 1.0}

      t = Transform.translate({2.0, 3.0, 4.0})

      assert t.matrix == expected
      assert t.inverse_matrix == Matrix.inverse(expected)
    end
  end

  describe "Raytracer.Transform.transpose/1" do
    test "transposes the matrix of a transformation" do
      t = %Transform{matrix: {1.0, 0.0, 0.0, 1.0,
                              0.0, 1.0, 0.0, 1.0,
                              0.0, 0.0, 1.0, 1.0,
                              0.0, 0.0, 0.0, 1.0},
                     inverse_matrix: {1.0, 0.0, 0.0, -1.0,
                                      0.0, 1.0, 0.0, -1.0,
                                      0.0, 0.0, 1.0, -1.0,
                                      0.0, 0.0, 0.0,  1.0}}

      transpose_t = Transform.transpose(t)

      assert transpose_t.matrix == Matrix.transpose(t.matrix)
      assert transpose_t.inverse_matrix == Matrix.transpose(t.inverse_matrix)
    end
  end
end
