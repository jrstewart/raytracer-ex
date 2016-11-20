defmodule Raytracer.Point2Test do
  use ExUnit.Case, async: true

  alias Raytracer.Point2
  alias Raytracer.Vector2

  describe "Raytracer.Point2.abs/1" do
    test "returns the point with absolute value of each coordinate" do
      p = %Point2{x: -1.0, y: -2.0}

      assert Point2.abs(p) == %Point2{x: 1.0, y: 2.0}
    end
  end

  describe "Raytracer.Point2.add/2" do
    test "adds two points and returns the resulting point" do
      p1 = %Point2{x: 1.0, y: 2.0}
      p2 = %Point2{x: 4.0, y: 5.0}

      assert Point2.add(p1, p2) == %Point2{x: 5.0, y: 7.0}
    end

    test "adds a point and a vector and returns the resulting point" do
      p = %Point2{x: 1.0, y: 2.0}
      v = %Vector2{dx: 4.0, dy: 5.0}

      assert Point2.add(p, v) == %Point2{x: 5.0, y: 7.0}
    end
  end

  describe "Raytracer.Point2.distance_between/2" do
    test "computes the distance between two points" do
      p1 = %Point2{x: 0.0, y: 0.0}
      p2 = %Point2{x: 2.0, y: 0.0}

      assert Point2.distance_between(p1, p2) == 2.0
    end
  end

  describe "Raytracer.Point2.distance_between_squared/2" do
    test "computes the squared distance between two points" do
      p1 = %Point2{x: 0.0, y: 0.0}
      p2 = %Point2{x: 2.0, y: 0.0}

      assert Point2.distance_between_squared(p1, p2) == 4.0
    end
  end

  describe "Raytracer.Point2.divide/2" do
    test "divides a point by a scalar value and returns the resulting point" do
      p = %Point2{x: 2.0, y: 4.0}
      scalar = 2.0

      assert Point2.divide(p, scalar) == %Point2{x: 1.0, y: 2.0}
    end

    test "raises an error when scalar is 0" do
      p = %Point2{}
      scalar = 0.0

      assert_raise ArgumentError, fn ->
        Point2.divide(p, scalar)
      end
    end
  end

  describe "Raytracer.Point2.lerp/3" do
    test "linearly interpolates between two points" do
      p1 = %Point2{x: 1.0, y: 1.0}
      p2 = %Point2{x: -1.0, y: -1.0}

      assert Point2.lerp(0.5, p1, p2) == %Point2{x: 0.0, y: 0.0}
    end
  end

  describe "Raytracer.Point2.multiply/2" do
    test "multiplies a point by a scalar value and returns the resulting point" do
      p = %Point2{x: 2.0, y: 4.0}
      scalar = 2.0

      assert Point2.multiply(p, scalar) == %Point2{x: 4.0, y: 8.0}
    end
  end

  describe "Raytracer.Point2.subtract/2" do
    test "subtracts a vector from a point and returns the resulting point" do
      p = %Point2{x: 1.0, y: 2.0}
      v = %Vector2{dx: 4.0, dy: 5.0}

      assert Point2.subtract(p, v) == %Point2{x: -3.0, y: -3.0}
    end

    test "subtracts two points and returns the resulting vector" do
      p1 = %Point2{x: 1.0, y: 2.0}
      p2 = %Point2{x: 4.0, y: 5.0}

      assert Point2.subtract(p1, p2) == %Vector2{dx: -3.0, dy: -3.0}
    end
  end
end
