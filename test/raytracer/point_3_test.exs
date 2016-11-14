defmodule Raytracer.Point3Test do
  use ExUnit.Case, async: true

  alias Raytracer.Point3
  alias Raytracer.Vector3

  describe "Raytracer.Point3.add/2" do
    test "adds two points and returns the resulting point" do
      p1 = %Point3{x: 1.0, y: 2.0, z: 3.0}
      p2 = %Point3{x: 4.0, y: 5.0, z: 6.0}

      assert Point3.add(p1, p2) == %Point3{x: 5.0, y: 7.0, z: 9.0}
    end

    test "adds a point and a vector and returns the resulting point" do
      p = %Point3{x: 1.0, y: 2.0, z: 3.0}
      v = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}

      assert Point3.add(p, v) == %Point3{x: 5.0, y: 7.0, z: 9.0}
    end
  end

  describe "Raytracer.Point3.distance_between/2" do
    test "computes the distance between two points" do
      p1 = %Point3{x: 0.0, y: 0.0, z: 0.0}
      p2 = %Point3{x: 2.0, y: 0.0, z: 0.0}

      assert Point3.distance_between(p1, p2) == 2.0
    end
  end

  describe "Raytracer.Point3.squared_distance_between/2" do
    test "computes the squared distance between two points" do
      p1 = %Point3{x: 0.0, y: 0.0, z: 0.0}
      p2 = %Point3{x: 2.0, y: 0.0, z: 0.0}

      assert Point3.squared_distance_between(p1, p2) == 4.0
    end
  end

  describe "Raytracer.Point3.subtract/2" do
    test "subtracts a vector from a point and returns the resulting point" do
      p = %Point3{x: 1.0, y: 2.0, z: 3.0}
      v = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}

      assert Point3.subtract(p, v) == %Point3{x: -3.0, y: -3.0, z: -3.0}
    end

    test "subtracts two points and returns the resulting vector" do
      p1 = %Point3{x: 1.0, y: 2.0, z: 3.0}
      p2 = %Point3{x: 4.0, y: 5.0, z: 6.0}

      assert Point3.subtract(p1, p2) == %Vector3{dx: -3.0, dy: -3.0, dz: -3.0}
    end
  end
end
