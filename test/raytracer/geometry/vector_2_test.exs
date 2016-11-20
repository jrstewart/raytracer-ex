defmodule Raytracer.Geometry.Vector2Test do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.Vector2
  alias Raytracer.Geometry.Point2

  describe "Raytracer.Geometry.Vector2.abs/1" do
    test "returns the vector with absolute value of each component" do
      v = %Vector2{dx: -1.0, dy: -2.0}

      assert Vector2.abs(v) == %Vector2{dx: 1.0, dy: 2.0}
    end
  end

  describe "Raytracer.Geometry.Vector2.add/2" do
    test "adds two vectors and returns the resulting vector" do
      v1 = %Vector2{dx: 1.0, dy: 2.0}
      v2 = %Vector2{dx: 4.0, dy: 5.0}

      assert Vector2.add(v1, v2) == %Vector2{dx: 5.0, dy: 7.0}
    end

    test "adds a vector and a point and returns the resulting point" do
      p = %Point2{x: 1.0, y: 2.0}
      v = %Vector2{dx: 4.0, dy: 5.0}

      assert Vector2.add(v, p) == %Point2{x: 5.0, y: 7.0}
    end
  end

  describe "Raytracer.Geometry.Vector2.divide/2" do
    test "divides a vector by a scalar value and returns the resulting vector" do
      v = %Vector2{dx: 2.0, dy: 4.0}
      scalar = 2.0

      assert Vector2.divide(v, scalar) == %Vector2{dx: 1.0, dy: 2.0}
    end

    test "raises an error when scalar is 0" do
      v = %Vector2{}
      scalar = 0.0

      assert_raise ArgumentError, fn ->
        Vector2.divide(v, scalar)
      end
    end
  end

  describe "Raytracer.Geometry.Vector2.dot/2" do
    test "computes the dot product of two vectors" do
      v1 = %Vector2{dx: 1.0, dy: 1.0}
      v2 = %Vector2{dx: 2.0, dy: 2.0}

      assert Vector2.dot(v1, v2) == 4.0
    end
  end

  describe "Raytracer.Geometry.Vector2.length/1" do
    test "computes the length of a vector" do
      v1 = %Vector2{dx: 1.0, dy: 0.0}
      v2 = %Vector2{dx: 0.0, dy: 2.0}

      assert Vector2.length(v1) == 1.0
      assert Vector2.length(v2) == 2.0
    end
  end

  describe "Raytracer.Geometry.Vector2.length_squared/1" do
    test "computes the squared length of a vector" do
      v1 = %Vector2{dx: 1.0, dy: 0.0}
      v2 = %Vector2{dx: 0.0, dy: 2.0}

      assert Vector2.length_squared(v1) == 1.0
      assert Vector2.length_squared(v2) == 4.0
    end
  end

  describe "Raytracer.Geometry.Vector2.max_component/1" do
    test "returns the largest component value of a vector" do
      v1 = %Vector2{dx: 1.0, dy: 2.0}
      v2 = %Vector2{dx: 4.0, dy: 2.0}

      assert Vector2.max_component(v1) == 2.0
      assert Vector2.max_component(v2) == 4.0
    end
  end

  describe "Raytracer.Geometry.Vector2.min_component/1" do
    test "returns the smallest component value of a vector" do
      v1 = %Vector2{dx: 1.0, dy: 2.0}
      v2 = %Vector2{dx: 2.0, dy: -1.0}

      assert Vector2.min_component(v1) == 1.0
      assert Vector2.min_component(v2) == -1.0
    end
  end

  describe "Raytracer.Geometry.Vector2.multiply/2" do
    test "multiplies a vector by a scalar value and returns the resulting vector" do
      v = %Vector2{dx: 2.0, dy: 4.0}
      scalar = 2.0

      assert Vector2.multiply(v, scalar) == %Vector2{dx: 4.0, dy: 8.0}
    end
  end

  describe "Raytracer.Geometry.Vector2.negate/1" do
    test "returns the vector pointing in the opposite direction of the given vector" do
      v = %Vector2{dx: 1.0, dy: 2.0}

      assert Vector2.negate(v) == %Vector2{dx: -1.0, dy: -2.0}
    end
  end

  describe "Raytracer.Geometry.Vector2.normalize/1" do
    test "normalizes the given vector" do
      v1 = %Vector2{dx: 10.0, dy: 0.0}
      v2 = %Vector2{dx: 0.0, dy: 8.0}

      assert Vector2.normalize(v1) == %Vector2{dx: 1.0, dy: 0.0}
      assert Vector2.normalize(v2) == %Vector2{dx: 0.0, dy: 1.0}
    end
  end

  describe "Raytracer.Geometry.Vector2.subtract/2" do
    test "subtracts two vectors and returns the resulting vector" do
      v1 = %Vector2{dx: 1.0, dy: 5.0}
      v2 = %Vector2{dx: 2.0, dy: 3.0}

      assert Vector2.subtract(v1, v2) == %Vector2{dx: -1.0, dy: 2.0}
    end
  end
end
