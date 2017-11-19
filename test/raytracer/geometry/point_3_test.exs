defmodule Raytracer.Geometry.Point3Test do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.{Point3, Vector3}
  alias Raytracer.{Transform, Transformable}

  describe "Raytracer.Geometry.Point3.abs/1" do
    test "returns the point with absolute value of each coordinate" do
      point = %Point3{x: -1.0, y: -2.0, z: -3.0}

      assert Point3.abs(point) == %Point3{x: 1.0, y: 2.0, z: 3.0}
    end
  end

  describe "Raytracer.Geometry.Point3.add/2" do
    test "adds two points and returns the resulting point" do
      point1 = %Point3{x: 1.0, y: 2.0, z: 3.0}
      point2 = %Point3{x: 4.0, y: 5.0, z: 6.0}

      assert Point3.add(point1, point2) == %Point3{x: 5.0, y: 7.0, z: 9.0}
    end

    test "adds a point and a vector and returns the resulting point" do
      point = %Point3{x: 1.0, y: 2.0, z: 3.0}
      vector = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}

      assert Point3.add(point, vector) == %Point3{x: 5.0, y: 7.0, z: 9.0}
    end
  end

  describe "Raytracer.Geometry.Point3.distance_between/2" do
    test "computes the distance between two points" do
      point1 = %Point3{x: 0.0, y: 0.0, z: 0.0}
      point2 = %Point3{x: 1.0, y: 2.0, z: 3.0}

      assert_in_delta Point3.distance_between(point1, point2), 3.7416573, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Point3.distance_between_squared/2" do
    test "computes the squared distance between two points" do
      point1 = %Point3{x: 0.0, y: 0.0, z: 0.0}
      point2 = %Point3{x: 1.0, y: 2.0, z: 3.0}

      assert_in_delta Point3.distance_between_squared(point1, point2), 14.0, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Point3.divide/2" do
    test "divides a point by a scalar value" do
      point = %Point3{x: 2.0, y: 4.0, z: 6.0}
      scalar = 2.0

      assert Point3.divide(point, scalar) == %Point3{x: 1.0, y: 2.0, z: 3.0}
    end
  end

  describe "Raytracer.Geometry.Point3.lerp/3" do
    test "linearly interpolates between two points" do
      point1 = %Point3{x: 1.0, y: 1.0, z: 1.0}
      point2 = %Point3{x: -1.0, y: -1.0, z: -1.0}

      assert Point3.lerp(point1, point2, 0.5) == %Point3{x: 0.0, y: 0.0, z: 0.0}
      assert Point3.lerp(point1, point2, 0.0) == point1
      assert Point3.lerp(point1, point2, 1.0) == point2
    end
  end

  describe "Raytracer.Geometry.Point3.multiply/2" do
    test "multiplies a point by a scalar value" do
      point = %Point3{x: 2.0, y: 4.0, z: 6.0}
      scalar = 2.0

      assert Point3.multiply(point, scalar) == %Point3{x: 4.0, y: 8.0, z: 12.0}
    end
  end

  describe "Raytracer.Geometry.Point3.subtract/2" do
    test "subtracts two points and returns the resulting vector" do
      point1 = %Point3{x: 1.0, y: 2.0, z: 3.0}
      point2 = %Point3{x: 4.0, y: 5.0, z: 6.0}

      assert Point3.subtract(point1, point2) == %Vector3{dx: -3.0, dy: -3.0, dz: -3.0}
    end

    test "subtracts a point and a vector and returns the resulting point" do
      point = %Point3{x: 1.0, y: 2.0, z: 3.0}
      vector = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}

      assert Point3.subtract(point, vector) == %Point3{x: -3.0, y: -3.0, z: -3.0}
    end
  end

  describe "Raytracer.Transformable.apply_transform/2" do
    test "transforms a point and returns the result" do
      transform = Transform.translate({2.0, 3.0, 4.0})
      point = %Point3{x: 2.0, y: 3.0, z: 4.0}

      assert Transformable.apply_transform(point, transform) == %Point3{x: 4.0, y: 6.0, z: 8.0}
    end

    test "transforms a point with a transform that has a non-homogeneous weight" do
      transform = Transform.from_matrix({
        4.0, 0.0, 0.0, 0.0,
        0.0, 4.0, 0.0, 0.0,
        0.0, 0.0, 4.0, 0.0,
        0.0, 0.0, 0.0, 2.0
      })
      point = %Point3{x: 2.0, y: 3.0, z: 4.0}

      assert Transformable.apply_transform(point, transform) == %Point3{x: 4.0, y: 6.0, z: 8.0}
    end
  end
end
