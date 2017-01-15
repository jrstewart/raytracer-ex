defmodule Raytracer.Geometry.PointTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.Point
  alias Raytracer.Transform

  describe "Raytracer.Geometry.Point.abs/1" do
    test "returns the point with absolute value of each coordinate" do
      assert Point.abs({-1.0, -2.0}) == {1.0, 2.0}
      assert Point.abs({-1.0, -2.0, -3.0}) == {1.0, 2.0, 3.0}
    end
  end

  describe "Raytracer.Geometry.Point.add/2" do
    test "adds two points and returns the resulting point" do
      assert Point.add({1.0, 2.0}, {4.0, 5.0}) == {5.0, 7.0}
      assert Point.add({1.0, 2.0, 3.0}, {4.0, 5.0, 6.0}) == {5.0, 7.0, 9.0}
    end
  end

  describe "Raytracer.Geometry.Point.apply_transform/2" do
    test "transforms a point and returns the result" do
      t = Transform.translate({2.0, 3.0, 4.0})
      p = {2.0, 3.0, 4.0}

      assert Point.apply_transform(p, t) == {4.0, 6.0, 8.0}
    end

    test "transforms a point with a transform that has a non-homogeneous weight" do
      t =
        {
          4.0, 0.0, 0.0, 0.0,
          0.0, 4.0, 0.0, 0.0,
          0.0, 0.0, 4.0, 0.0,
          0.0, 0.0, 0.0, 2.0,
        }
        |> Transform.from_matrix
      p = {2.0, 3.0, 4.0}

      assert Point.apply_transform(p, t) == {4.0, 6.0, 8.0}
    end
  end

  describe "Raytracer.Geometry.Point.distance_between/2" do
    test "computes the distance between two points" do
      assert Point.distance_between({0.0, 0.0}, {2.0, 0.0}) == 2.0
      assert Point.distance_between({0.0, 0.0, 0.0}, {2.0, 0.0, 0.0}) == 2.0
    end
  end

  describe "Raytracer.Geometry.Point.distance_between_squared/2" do
    test "computes the squared distance between two points" do
      assert Point.distance_between_squared({0.0, 0.0}, {2.0, 0.0}) == 4.0
      assert Point.distance_between_squared({0.0, 0.0, 0.0}, {2.0, 0.0, 0.0}) == 4.0
    end
  end

  describe "Raytracer.Geometry.Point.divide/2" do
    test "divides a point by a scalar value" do
      scalar = 2.0

      assert Point.divide({2.0, 4.0}, scalar) == {1.0, 2.0}
      assert Point.divide({2.0, 4.0, 6.0}, scalar) == {1.0, 2.0, 3.0}
    end
  end

  describe "Raytracer.Geometry.Point.lerp/3" do
    test "linearly interpolates between two points" do
      p1 = {1.0, 1.0}
      p2 = {-1.0, -1.0}

      assert Point.lerp(p1, p2, 0.5) == {0.0, 0.0}
      assert Point.lerp(p1, p2, 0.0) == p1
      assert Point.lerp(p1, p2, 1.0) == p2

      p1 = {1.0, 1.0, 1.0}
      p2 = {-1.0, -1.0, -1.0}

      assert Point.lerp(p1, p2, 0.5) == {0.0, 0.0, 0.0}
      assert Point.lerp(p1, p2, 0.0) == p1
      assert Point.lerp(p1, p2, 1.0) == p2
    end
  end

  describe "Raytracer.Geometry.Point.multiply/2" do
    test "multiplies a point by a scalar value" do
      scalar = 2.0

      assert Point.multiply({2.0, 4.0}, scalar) == {4.0, 8.0}
      assert Point.multiply({2.0, 4.0, 6.0}, scalar) == {4.0, 8.0, 12.0}
    end
  end

  describe "Raytracer.Geometry.Point.subtract/2" do
    test "subtracts two points and returns the resulting vector" do
      assert Point.subtract({1.0, 2.0}, {4.0, 5.0}) == {-3.0, -3.0}
      assert Point.subtract({1.0, 2.0, 3.0}, {4.0, 5.0, 6.0}) == {-3.0, -3.0, -3.0}
    end
  end
end
