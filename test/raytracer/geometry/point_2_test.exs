defmodule Raytracer.Geometry.Point2Test do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.{Point2, Vector2}

  describe "Raytracer.Geometry.Point2.abs/1" do
    test "returns the point with absolute value of each coordinate" do
      point = %Point2{x: -1.0, y: -2.0}

      assert Point2.abs(point) == %Point2{x: 1.0, y: 2.0}
    end
  end

  describe "Raytracer.Geometry.Point2.add/2" do
    test "adds two points and returns the resulting point" do
      point1 = %Point2{x: 1.0, y: 2.0}
      point2 = %Point2{x: 4.0, y: 5.0}

      assert Point2.add(point1, point2) == %Point2{x: 5.0, y: 7.0}
    end

    test "adds a point and a vector and returns the resulting point" do
      point = %Point2{x: 1.0, y: 2.0}
      vector = %Vector2{dx: 4.0, dy: 5.0}

      assert Point2.add(point, vector) == %Point2{x: 5.0, y: 7.0}
    end
  end

  describe "Raytracer.Geometry.Point2.distance_between/2" do
    test "computes the distance between two points" do
      point1 = %Point2{x: 0.0, y: 0.0}
      point2 = %Point2{x: 1.0, y: 2.0}

      assert_in_delta Point2.distance_between(point1, point2), 2.236067977, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Point2.distance_between_squared/2" do
    test "computes the squared distance between two points" do
      point1 = %Point2{x: 0.0, y: 0.0}
      point2 = %Point2{x: 1.0, y: 2.0}

      assert_in_delta Point2.distance_between_squared(point1, point2), 5.0, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Point2.divide/2" do
    test "divides a point by a scalar value" do
      point = %Point2{x: 2.0, y: 4.0}
      scalar = 2.0

      assert Point2.divide(point, scalar) == %Point2{x: 1.0, y: 2.0}
    end
  end

  describe "Raytracer.Geometry.Point2.lerp/3" do
    test "linearly interpolates between two points" do
      point1 = %Point2{x: 1.0, y: 1.0}
      point2 = %Point2{x: -1.0, y: -1.0}

      assert Point2.lerp(point1, point2, 0.5) == %Point2{x: 0.0, y: 0.0}
      assert Point2.lerp(point1, point2, 0.0) == point1
      assert Point2.lerp(point1, point2, 1.0) == point2
    end
  end

  describe "Raytracer.Geometry.Point2.multiply/2" do
    test "multiplies a point by a scalar value" do
      point = %Point2{x: 2.0, y: 4.0}
      scalar = 2.0

      assert Point2.multiply(point, scalar) == %Point2{x: 4.0, y: 8.0}
    end
  end

  describe "Raytracer.Geometry.Point2.subtract/2" do
    test "subtracts two points and returns the resulting vector" do
      point1 = %Point2{x: 1.0, y: 2.0}
      point2 = %Point2{x: 4.0, y: 5.0}

      assert Point2.subtract(point1, point2) == %Vector2{dx: -3.0, dy: -3.0}
    end

    test "subtracts a point and a vector and returns the resulting point" do
      point = %Point2{x: 1.0, y: 2.0}
      vector = %Vector2{dx: 4.0, dy: 5.0}

      assert Point2.subtract(point, vector) == %Point2{x: -3.0, y: -3.0}
    end
  end
end
