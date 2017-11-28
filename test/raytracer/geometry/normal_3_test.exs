defmodule Raytracer.Geometry.Normal3Test do
  use ExUnit.Case, async: true

  alias Raytracer.{Transform, Transformable}
  alias Raytracer.Geometry.{Normal3, Vector3}

  describe "Raytracer.Geometry.Normal3.abs/1" do
    test "returns the normal with the absolute value of each component" do
      normal = %Normal3{dx: -1.0, dy: -2.0, dz: -3.0}

      assert Normal3.abs(normal) == %Normal3{dx: 1.0, dy: 2.0, dz: 3.0}
    end
  end

  describe "Raytracer.Geometry.Normal3.add/2" do
    test "adds two normals" do
      normal1 = %Normal3{dx: 1.0, dy: 2.0, dz: 3.0}
      normal2 = %Normal3{dx: 4.0, dy: 5.0, dz: 6.0}

      assert Normal3.add(normal1, normal2) == %Normal3{dx: 5.0, dy: 7.0, dz: 9.0}
    end
  end

  describe "Raytracer.Geometry.Normal3.cross/2" do
    test "computes the cross product of a normal and a vector" do
      normal = %Normal3{dx: 2.0, dy: 3.0, dz: 4.0}
      vector = %Vector3{dx: 5.0, dy: 6.0, dz: 7.0}

      assert Normal3.cross(normal, vector) == %Vector3{dx: -3.0, dy: 6.0, dz: -3.0}
    end
  end

  describe "Raytracer.Geometry.Normal3.divide/2" do
    test "divides a normal by a scalar value" do
      normal = %Normal3{dx: 2.0, dy: 4.0, dz: 6.0}
      scalar = 2.0

      assert Normal3.divide(normal, scalar) == %Normal3{dx: 1.0, dy: 2.0, dz: 3.0}
    end
  end

  describe "Raytracer.Geometry.Normal3.dot/2" do
    test "computes the dot product of two normals" do
      normal1 = %Normal3{dx: 1.0, dy: 2.0, dz: 3.0}
      normal2 = %Normal3{dx: 4.0, dy: 5.0, dz: 6.0}

      assert Normal3.dot(normal1, normal2) == 32.0
    end

    test "computes the dot product of a normal and a vector" do
      normal = %Normal3{dx: 1.0, dy: 2.0, dz: 3.0}
      vector = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}

      assert Normal3.dot(normal, vector) == 32.0
    end
  end

  describe "Raytracer.Geometry.Normal3.length/1" do
    test "computes the length of a normal" do
      normal = %Normal3{dx: 1.0, dy: 2.0, dz: 3.0}

      assert_in_delta Normal3.length(normal), 3.7416573, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Normal3.length_squared/1" do
    test "computes the squared length of a normal" do
      normal = %Normal3{dx: 1.0, dy: 2.0, dz: 3.0}

      assert_in_delta Normal3.length_squared(normal), 14.0, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Normal3.multiply/2" do
    test "multiplies a normal by a scalar value" do
      normal = %Normal3{dx: 2.0, dy: 4.0, dz: 6.0}
      scalar = 2.0

      assert Normal3.multiply(normal, scalar) == %Normal3{dx: 4.0, dy: 8.0, dz: 12.0}
    end
  end

  describe "Raytracer.Geometry.Normal3.negate/1" do
    test "returns the normal pointing in the opposite direction of the given normal" do
      normal = %Normal3{dx: 1.0, dy: 2.0, dz: -1.0}

      assert Normal3.negate(normal) == %Normal3{dx: -1.0, dy: -2.0, dz: 1.0}
    end
  end

  describe "Raytracer.Geometry.Normal3.normalize/1" do
    test "normalizes a normal" do
      normal = %Normal3{dx: 10.0, dy: 8.0, dz: 5.0}

      result = Normal3.normalize(normal)

      assert_in_delta result.dx, 0.72739297, 1.0e-7
      assert_in_delta result.dy, 0.58191437, 1.0e-7
      assert_in_delta result.dz, 0.36369648, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Normal3.subtract/2" do
    test "subtracts two normals" do
      normal1 = %Normal3{dx: 1.0, dy: 5.0, dz: 4.0}
      normal2 = %Normal3{dx: 2.0, dy: 3.0, dz: 7.0}

      assert Normal3.subtract(normal1, normal2) == %Normal3{dx: -1.0, dy: 2.0, dz: -3.0}
    end
  end

  describe "Raytracer.Transformable.apply_transform/2" do
    test "transforms a normal and returns the result" do
      transform = Transform.translate(2.0, 3.0, 4.0)
      normal = %Normal3{dx: 2.0, dy: 3.0, dz: 4.0}

      assert Transformable.apply_transform(normal, transform) ==
               %Normal3{dx: 2.0, dy: 3.0, dz: 4.0}

      transform = Transform.scale(2.0, 3.0, 4.0)
      normal = %Normal3{dx: 2.0, dy: 3.0, dz: 4.0}

      assert Transformable.apply_transform(normal, transform) ==
               %Normal3{dx: 1.0, dy: 1.0, dz: 1.0}
    end
  end
end
