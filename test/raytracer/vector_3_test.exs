defmodule Raytracer.Vector3Test do
  use ExUnit.Case, async: true

  alias Raytracer.Vector3

  describe "Raytracer.Vector3.add/2" do
    test "adds two vectors and returns the resulting vector" do
      v1 = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
      v2 = %Vector3{dx: 4.0, dy: 5.0, dz: 6.0}

      assert Vector3.add(v1, v2) == %Vector3{dx: 5.0, dy: 7.0, dz: 9.0}
    end
  end

  describe "Raytracer.Vector3.cross/2" do
    test "computes the cross product of two vectors" do
      v1 = %Vector3{dx: 2.0, dy: 3.0, dz: 4.0}
      v2 = %Vector3{dx: 5.0, dy: 6.0, dz: 7.0}

      assert Vector3.cross(v1, v2) == %Vector3{dx: -3.0, dy: 6.0, dz: -3.0}
    end
  end

  describe "Raytracer.Vector3.divide/2" do
    test "divides a vector by a scalar value and returns the resulting vector" do
      v = %Vector3{dx: 2.0, dy: 4.0, dz: 6.0}
      scalar = 2.0

      assert Vector3.divide(v, scalar) == %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
    end
  end

  describe "Raytracer.Vector3.dot/2" do
    test "computes the dot product of two vectors" do
      v1 = %Vector3{dx: 1.0, dy: 1.0, dz: 1.0}
      v2 = %Vector3{dx: 2.0, dy: 2.0, dz: 2.0}

      assert Vector3.dot(v1, v2) == 6.0
    end
  end

  describe "Raytracer.Vector3.length/1" do
    test "computes the length of a vector" do
      v1 = %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}
      v2 = %Vector3{dx: 0.0, dy: 2.0, dz: 0.0}
      v3 = %Vector3{dx: 0.0, dy: 0.0, dz: 3.0}

      assert Vector3.length(v1) == 1.0
      assert Vector3.length(v2) == 2.0
      assert Vector3.length(v3) == 3.0
    end
  end

  describe "Raytracer.Vector3.multiply/2" do
    test "multiplies a vector by a scalar value and returns the resulting vector" do
      v = %Vector3{dx: 2.0, dy: 4.0, dz: 6.0}
      scalar = 2.0

      assert Vector3.multiply(v, scalar) == %Vector3{dx: 4.0, dy: 8.0, dz: 12.0}
    end
  end

  describe "Raytracer.Vector3.normalize/1" do
    test "normalizes the given vector" do
      v1 = %Vector3{dx: 10.0, dy: 0.0, dz: 0.0}
      v2 = %Vector3{dx: 0.0, dy: 8.0, dz: 0.0}
      v3 = %Vector3{dx: 0.0, dy: 0.0, dz: 6.0}

      assert Vector3.normalize(v1) == %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}
      assert Vector3.normalize(v2) == %Vector3{dx: 0.0, dy: 1.0, dz: 0.0}
      assert Vector3.normalize(v3) == %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
    end
  end

  describe "Raytracer.Vector3.subtract/2" do
    test "subtracts two vectors and returns the resulting vector" do
      v1 = %Vector3{dx: 1.0, dy: 5.0, dz: 4.0}
      v2 = %Vector3{dx: 2.0, dy: 3.0, dz: 4.0}

      assert Vector3.subtract(v1, v2) == %Vector3{dx: -1.0, dy: 2.0, dz: 0.0}
    end
  end
end
