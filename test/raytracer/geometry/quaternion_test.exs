defmodule Raytracer.Geometry.QuaternionTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.Quaternion

  describe "Raytracer.Geometry.Quaternion.add/2" do
    test "adds two quaternions" do
      assert Quaternion.add({1.0, 2.0, 3.0, 4.0}, {5.0, 6.0, 7.0, 8.0}) == {6.0, 8.0, 10.0, 12.0}
    end
  end

  describe "Raytracer.Geometry.Quaternion.divide/2" do
    test "divides a quaternion by a scalar value" do
      assert Quaternion.divide({2.0, 4.0, 6.0, 8.0}, 2.0) == {1.0, 2.0, 3.0, 4.0}
    end
  end

  describe "Raytracer.Geometry.Quaternion.dot/2" do
    test "computes the dot product of two quaternions" do
      assert Quaternion.dot({1.0, 1.0, 1.0, 1.0}, {2.0, 2.0, 2.0, 2.0}) == 8.0
    end
  end

  describe "Raytracer.Geometry.Quaternion.multiply/2" do
    test "multiplies a quaternion by a scalar value" do
      assert Quaternion.multiply({2.0, 4.0, 6.0, 8.0}, 2.0) == {4.0, 8.0, 12.0, 16.0}
    end
  end

  describe "Raytracer.Geometry.Quaternion.normalize/1" do
    test "normalizes a quaternion" do
      assert Quaternion.normalize({10.0, 0.0, 0.0, 0.0}) == {1.0, 0.0, 0.0, 0.0}
      assert Quaternion.normalize({0.0, 10.0, 0.0, 0.0}) == {0.0, 1.0, 0.0, 0.0}
      assert Quaternion.normalize({0.0, 0.0, 10.0, 0.0}) == {0.0, 0.0, 1.0, 0.0}
      assert Quaternion.normalize({0.0, 0.0, 0.0, 10.0}) == {0.0, 0.0, 0.0, 1.0}
    end
  end

  describe "Raytracer.Geometry.Quaternion.slerp/3" do
    test "computes the spherical linear interpolates between two quaternions" do
      delta = 1.0e-7
      q1 = {1.0, 1.0, 0.0, 1.0}
      q2 = {-1.0, -1.0, 0.0, 1.0}

      result = Quaternion.slerp(q1, q2, 0.5)

      assert_in_delta elem(result, 0), 0.0, delta
      assert_in_delta elem(result, 1), 0.0, delta
      assert_in_delta elem(result, 2), 0.0, delta
      assert_in_delta elem(result, 3), 2.0, delta

      q1 = {2.0, 0.0, 0.0, 1.0}
      q2 = {0.0, 2.0, 0.0, 1.0}

      result = Quaternion.slerp(q1, q2, 0.5)

      assert_in_delta elem(result, 0), 0.5773502691896258, delta
      assert_in_delta elem(result, 1), 0.5773502691896258, delta
      assert_in_delta elem(result, 2), 0.0, delta
      assert_in_delta elem(result, 3), 0.5773502691896258, delta
    end
  end

  describe "Raytracer.Geometry.Quaternion.subtract/2" do
    test "subtracts two quaternions" do
      assert Quaternion.subtract({5.0, 6.0, 7.0, 8.0}, {1.0, 2.0, 3.0, 4.0}) == {4.0, 4.0, 4.0, 4.0}
    end
  end
end
