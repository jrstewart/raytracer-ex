defmodule Raytracer.Geometry.Vector3Test do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.{Point3, Vector3}

  describe "Raytracer.Geometry.Vector3.abs/1" do
    test "returns the vector with absolute value of each component" do
      v = %Vector3{dx: -1.0, dy: -2.0, dz: -3.0}

      assert Vector3.abs(v) == %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
    end
  end

  describe "Raytracer.Geometry.Vector3.add/2" do
    test "adds two vectors and returns the resulting vector" do
      v1 = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
      v2 = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}

      assert Vector3.add(v1, v2) == %Vector3{dx: 5.0, dy: 7.0, dz: 9.0}
    end

    test "adds a vector and a point and returns the resulting point" do
      p = %Point3{x: 1.0, y: 2.0, z: 3.0}
      v = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}

      assert Vector3.add(v, p) == %Point3{x: 5.0, y: 7.0, z: 9.0}
    end
  end

  describe "Raytracer.Geometry.Vector3.cross/2" do
    test "computes the cross product of two vectors" do
      v1 = %Vector3{dx: 2.0, dy: 3.0, dz: 4.0}
      v2 = %Vector3{dx: 5.0, dy: 6.0, dz: 7.0}

      assert Vector3.cross(v1, v2) == %Vector3{dx: -3.0, dy: 6.0, dz: -3.0}
    end
  end

  describe "Raytracer.Geometry.Vector3.divide/2" do
    test "divides a vector by a scalar value and returns the resulting vector" do
      v = %Vector3{dx: 2.0, dy: 4.0, dz: 6.0}
      scalar = 2.0

      assert Vector3.divide(v, scalar) == %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
    end

    test "raises an error when scalar is 0" do
      v = %Vector3{}
      scalar = 0.0

      assert_raise ArgumentError, fn ->
        Vector3.divide(v, scalar)
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.dot/2" do
    test "computes the dot product of two vectors" do
      v1 = %Vector3{dx: 1.0, dy: 1.0, dz: 1.0}
      v2 = %Vector3{dx: 2.0, dy: 2.0, dz: 2.0}

      assert Vector3.dot(v1, v2) == 6.0
    end
  end

  describe "Raytracer.Geometry.Vector3.length/1" do
    test "computes the length of a vector" do
      v1 = %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}
      v2 = %Vector3{dx: 0.0, dy: 2.0, dz: 0.0}
      v3 = %Vector3{dx: 0.0, dy: 0.0, dz: 3.0}

      assert Vector3.length(v1) == 1.0
      assert Vector3.length(v2) == 2.0
      assert Vector3.length(v3) == 3.0
    end
  end

  describe "Raytracer.Geometry.Vector3.length_squared/1" do
    test "computes the squared length of a vector" do
      v1 = %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}
      v2 = %Vector3{dx: 0.0, dy: 2.0, dz: 0.0}
      v3 = %Vector3{dx: 0.0, dy: 0.0, dz: 3.0}

      assert Vector3.length_squared(v1) == 1.0
      assert Vector3.length_squared(v2) == 4.0
      assert Vector3.length_squared(v3) == 9.0
    end
  end

  describe "Raytracer.Geometry.Vector3.max_component/1" do
    test "returns the largest component value of a vector" do
      v1 = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
      v2 = %Vector3{dx: 2.0, dy: 4.0, dz: -1.0}
      v3 = %Vector3{dx: 5.0, dy: 1.0, dz: -2.0}

      assert Vector3.max_component(v1) == 3.0
      assert Vector3.max_component(v2) == 4.0
      assert Vector3.max_component(v3) == 5.0
    end
  end

  describe "Raytracer.Geometry.Vector3.min_component/1" do
    test "returns the smallest component value of a vector" do
      v1 = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
      v2 = %Vector3{dx: 2.0, dy: 4.0, dz: -1.0}
      v3 = %Vector3{dx: 5.0, dy: -1.0, dz: 2.0}

      assert Vector3.min_component(v1) == 1.0
      assert Vector3.min_component(v2) == -1.0
      assert Vector3.min_component(v3) == -1.0
    end
  end

  describe "Raytracer.Geometry.Vector3.multiply/2" do
    test "multiplies a vector by a scalar value and returns the resulting vector" do
      v = %Vector3{dx: 2.0, dy: 4.0, dz: 6.0}
      scalar = 2.0

      assert Vector3.multiply(v, scalar) == %Vector3{dx: 4.0, dy: 8.0, dz: 12.0}
    end
  end

  describe "Raytracer.Geometry.Vector3.negate/1" do
    test "returns the vector pointing in the opposite direction of the given vector" do
      v = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}

      assert Vector3.negate(v) == %Vector3{dx: -1.0, dy: -2.0, dz: -3.0}
    end
  end

  describe "Raytracer.Geometry.Vector3.normalize/1" do
    test "normalizes the given vector" do
      v1 = %Vector3{dx: 10.0, dy: 0.0, dz: 0.0}
      v2 = %Vector3{dx: 0.0, dy: 8.0, dz: 0.0}
      v3 = %Vector3{dx: 0.0, dy: 0.0, dz: 6.0}

      assert Vector3.normalize(v1) == %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}
      assert Vector3.normalize(v2) == %Vector3{dx: 0.0, dy: 1.0, dz: 0.0}
      assert Vector3.normalize(v3) == %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
    end
  end

  describe "Raytracer.Geometry.Vector3.subtract/2" do
    test "subtracts two vectors and returns the resulting vector" do
      v1 = %Vector3{dx: 1.0, dy: 5.0, dz: 4.0}
      v2 = %Vector3{dx: 2.0, dy: 3.0, dz: 4.0}

      assert Vector3.subtract(v1, v2) == %Vector3{dx: -1.0, dy: 2.0, dz: 0.0}
    end
  end
end
