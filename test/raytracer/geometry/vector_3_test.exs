defmodule Raytracer.Geometry.Vector3Test do
  use ExUnit.Case, async: true

  alias Raytracer.{Transform, Transformable}
  alias Raytracer.Geometry.{Normal3, Point3, Vector3}

  describe "Raytracer.Geometry.Vector3.abs/1" do
    test "returns the vector with absolute value of each coordinate" do
      vector = %Vector3{dx: -1.0, dy: -2.0, dz: -3.0}

      assert Vector3.abs(vector) == %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
    end
  end

  describe "Raytracer.Geometry.Vector3.add/2" do
    test "adds two vectors and returns the resulting vector" do
      vector1 = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
      vector2 = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}

      assert Vector3.add(vector1, vector2) == %Vector3{dx: 5.0, dy: 7.0, dz: 9.0}
    end

    test "adds a vector and a point and returns the resulting point" do
      vector = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}
      point = %Point3{x: 1.0, y: 2.0, z: 3.0}

      assert Vector3.add(vector, point) == %Point3{x: 5.0, y: 7.0, z: 9.0}
    end
  end

  describe "Raytracer.Geometry.Vector3.cross/2" do
    test "computes the cross product of two vectors" do
      vector1 = %Vector3{dx: 2.0, dy: 3.0, dz: 4.0}
      vector2 = %Vector3{dx: 5.0, dy: 6.0, dz: 7.0}

      assert Vector3.cross(vector1, vector2) == %Vector3{dx: -3.0, dy: 6.0, dz: -3.0}
    end

    test "computes the cross product of a vector and a normal" do
      vector = %Vector3{dx: 2.0, dy: 3.0, dz: 4.0}
      normal = %Normal3{dx: 5.0, dy: 6.0, dz: 7.0}

      assert Vector3.cross(vector, normal) == %Vector3{dx: -3.0, dy: 6.0, dz: -3.0}
    end
  end

  describe "Raytracer.Geometry.Vector3.divide/2" do
    test "divides a vector by a scalar value" do
      vector = %Vector3{dx: 2.0, dy: 4.0, dz: 6.0}
      scalar = 2.0

      assert Vector3.divide(vector, scalar) == %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
    end
  end

  describe "Raytracer.Geometry.Vector3.dot/2" do
    test "computes the dot product of two vectors" do
      vector1 = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
      vector2 = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}

      assert Vector3.dot(vector1, vector2) == 32.0
    end
  end

  describe "Raytracer.Geometry.Vector3.length/1" do
    test "computes the length of a vector" do
      vector = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}

      assert_in_delta Vector3.length(vector), 3.7416573, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Vector3.length_squared/1" do
    test "computes the squared length of a vector" do
      vector = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}

      assert_in_delta Vector3.length_squared(vector), 14.0, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Vector3.max_component/1" do
    test "returns the largest component value of a vector" do
      assert Vector3.max_component(%Vector3{dx: 1.0, dy: 2.0, dz: 3.0}) == 3.0
      assert Vector3.max_component(%Vector3{dx: 2.0, dy: 4.0, dz: -1.0}) == 4.0
      assert Vector3.max_component(%Vector3{dx: 5.0, dy: 1.0, dz: -2.0}) == 5.0
    end
  end

  describe "Raytracer.Geometry.Vector3.min_component/1" do
    test "returns the smallest component value of a vector" do
      assert Vector3.min_component(%Vector3{dx: 1.0, dy: 2.0, dz: 3.0}) == 1.0
      assert Vector3.min_component(%Vector3{dx: 2.0, dy: 4.0, dz: -1.0}) == -1.0
      assert Vector3.min_component(%Vector3{dx: 5.0, dy: -1.0, dz: 2.0}) == -1.0
    end
  end

  describe "Raytracer.Geometry.Vector3.multiply/2" do
    test "multiplies a point by a scalar value" do
      vector = %Vector3{dx: 2.0, dy: 4.0, dz: 6.0}
      scalar = 2.0

      assert Vector3.multiply(vector, scalar) == %Vector3{dx: 4.0, dy: 8.0, dz: 12.0}
    end
  end

  describe "Raytracer.Geometry.Vector3.negate/1" do
    test "returns the vector pointing in the opposite direction of the given vector" do
      vector = %Vector3{dx: 1.0, dy: 2.0, dz: -1.0}

      assert Vector3.negate(vector) == %Vector3{dx: -1.0, dy: -2.0, dz: 1.0}
    end
  end

  describe "Raytracer.Geometry.Vector3.normalize/1" do
    test "normalizes a vector" do
      vector = %Vector3{dx: 10.0, dy: 8.0, dz: 5.0}

      result = Vector3.normalize(vector)

      assert_in_delta result.dx, 0.72739297, 1.0e-7
      assert_in_delta result.dy, 0.58191437, 1.0e-7
      assert_in_delta result.dz, 0.36369648, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Vector3.subtract/2" do
    test "subtracts two vectors" do
      vector1 = %Vector3{dx: 1.0, dy: 5.0, dz: 4.0}
      vector2 = %Vector3{dx: 2.0, dy: 3.0, dz: 7.0}

      assert Vector3.subtract(vector1, vector2) == %Vector3{dx: -1.0, dy: 2.0, dz: -3.0}
    end
  end

  describe "Raytracer.Transformable.apply_transform/2" do
    test "transforms a vector and returns the result" do
      transform = Transform.scale({2.0, 3.0, 4.0})
      vector = %Vector3{dx: 2.0, dy: 3.0, dz: 4.0}

      assert Transformable.apply_transform(vector, transform) ==
               %Vector3{dx: 4.0, dy: 9.0, dz: 16.0}
    end
  end
end
