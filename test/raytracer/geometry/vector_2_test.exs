defmodule Raytracer.Geometry.Vector2Test do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.{Point2, Vector2}

  describe "Raytracer.Geometry.Vector2.abs/1" do
    test "returns the vector with absolute value of each coordinate" do
      vector = %Vector2{dx: -1.0, dy: -2.0}

      assert Vector2.abs(vector) == %Vector2{dx: 1.0, dy: 2.0}
    end
  end

  describe "Raytracer.Geometry.Vector2.add/2" do
    test "adds two vectors and returns the resulting vector" do
      vector1 = %Vector2{dx: 1.0, dy: 2.0}
      vector2 = %Vector2{dx: 4.0, dy: 5.0}

      assert Vector2.add(vector1, vector2) == %Vector2{dx: 5.0, dy: 7.0}
    end

    test "adds a vector and a point and returns the resulting point" do
      vector = %Vector2{dx: 4.0, dy: 5.0}
      point = %Point2{x: 1.0, y: 2.0}

      assert Vector2.add(vector, point) == %Point2{x: 5.0, y: 7.0}
    end
  end

  describe "Raytracer.Geometry.Vector2.divide/2" do
    test "divides a vector by a scalar value" do
      vector = %Vector2{dx: 2.0, dy: 4.0}
      scalar = 2.0

      assert Vector2.divide(vector, scalar) == %Vector2{dx: 1.0, dy: 2.0}
    end
  end

  describe "Raytracer.Geometry.Vector2.dot/2" do
    test "computes the dot product of two vectors" do
      vector1 = %Vector2{dx: 1.0, dy: 2.0}
      vector2 = %Vector2{dx: 3.0, dy: 4.0}

      assert Vector2.dot(vector1, vector2) == 11.0
    end
  end

  describe "Raytracer.Geometry.Vector2.length/1" do
    test "computes the length of a vector" do
      vector = %Vector2{dx: 1.0, dy: 2.0}

      assert_in_delta Vector2.length(vector), 2.236067977, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Vector2.length_squared/1" do
    test "computes the squared length of a vector" do
      vector = %Vector2{dx: 1.0, dy: 2.0}

      assert_in_delta Vector2.length_squared(vector), 5.0, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Vector2.max_component/1" do
    test "returns the largest component value of a vector" do
      assert Vector2.max_component(%Vector2{dx: 2.0, dy: 1.0}) == 2.0
      assert Vector2.max_component(%Vector2{dx: 2.0, dy: 4.0}) == 4.0
    end
  end

  describe "Raytracer.Geometry.Vector2.min_component/1" do
    test "returns the smallest component value of a vector" do
      assert Vector2.min_component(%Vector2{dx: 1.0, dy: 2.0}) == 1.0
      assert Vector2.min_component(%Vector2{dx: 2.0, dy: 1.0}) == 1.0
    end
  end

  describe "Raytracer.Geometry.Vector2.multiply/2" do
    test "multiplies a point by a scalar value" do
      vector = %Vector2{dx: 2.0, dy: 4.0}
      scalar = 2.0

      assert Vector2.multiply(vector, scalar) == %Vector2{dx: 4.0, dy: 8.0}
    end
  end

  describe "Raytracer.Geometry.Vector2.negate/1" do
    test "returns the vector pointing in the opposite direction of the given vector" do
      vector = %Vector2{dx: 1.0, dy: 2.0}

      assert Vector2.negate(vector) == %Vector2{dx: -1.0, dy: -2.0}
    end
  end

  describe "Raytracer.Geometry.Vector2.normalize/1" do
    test "normalizes a vector" do
      vector = %Vector2{dx: 10.0, dy: 8.0}

      result = Vector2.normalize(vector)

      assert_in_delta result.dx, 0.78086880, 1.0e-7
      assert_in_delta result.dy, 0.62469505, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Vector2.subtract/2" do
    test "subtracts two vectors" do
      vector1 = %Vector2{dx: 1.0, dy: 5.0}
      vector2 = %Vector2{dx: 2.0, dy: 3.0}

      assert Vector2.subtract(vector1, vector2) == %Vector2{dx: -1.0, dy: 2.0}
    end
  end
end
