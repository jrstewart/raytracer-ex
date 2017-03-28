defmodule Raytracer.Geometry.VectorTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.Vector
  alias Raytracer.Transform


  describe "Raytracer.Geometry.Vector.abs/1" do
    test "returns the vector with absolute value of each component" do
      assert Vector.abs({-1.0, -2.0}) == {1.0, 2.0}
      assert Vector.abs({-1.0, -2.0, -3.0}) == {1.0, 2.0, 3.0}
    end
  end


  describe "Raytracer.Geometry.Vector.add/2" do
    test "adds two vectors" do
      assert Vector.add({1.0, 2.0}, {4.0, 5.0}) == {5.0, 7.0}
      assert Vector.add({1.0, 2.0, 3.0}, {4.0, 5.0, 6.0}) == {5.0, 7.0, 9.0}
    end
  end


  describe "Raytracer.Geometry.Vector.apply_transform/2" do
    test "transforms a vector and returns the result" do
      t = Transform.scale({2.0, 3.0, 4.0})
      v = {2.0, 3.0, 4.0}

      assert Vector.apply_transform(v, t) == {4.0, 9.0, 16.0}
    end
  end


  describe "Raytracer.Geometry.Vector.cross/2" do
    test "computes the cross product of two vectors" do
      assert Vector.cross({2.0, 3.0, 4.0}, {5.0, 6.0, 7.0}) == {-3.0, 6.0, -3.0}
    end
  end


  describe "Raytracer.Geometry.Vector.divide/2" do
    test "divides a vector by a scalar value" do
      scalar = 2.0

      assert Vector.divide({2.0, 4.0}, scalar) == {1.0, 2.0}
      assert Vector.divide({2.0, 4.0, 6.0}, scalar) == {1.0, 2.0, 3.0}
    end
  end


  describe "Raytracer.Geometry.Vector.dot/2" do
    test "computes the dot product of two vectors" do
      assert Vector.dot({1.0, 1.0}, {2.0, 2.0}) == 4.0
      assert Vector.dot({1.0, 1.0, 1.0}, {2.0, 2.0, 2.0}) == 6.0
    end
  end


  describe "Raytracer.Geometry.Vector.length/1" do
    test "computes the length of a vector" do
      assert Vector.length({1.0, 0.0}) == 1.0
      assert Vector.length({0.0, 2.0}) == 2.0
      assert Vector.length({1.0, 0.0, 0.0}) == 1.0
      assert Vector.length({0.0, 2.0, 0.0}) == 2.0
      assert Vector.length({0.0, 0.0, 3.0}) == 3.0
    end
  end


  describe "Raytracer.Geometry.Vector.length_squared/1" do
    test "computes the squared length of a vector" do
      assert Vector.length_squared({1.0, 0.0}) == 1.0
      assert Vector.length_squared({0.0, 2.0}) == 4.0
      assert Vector.length_squared({1.0, 0.0, 0.0}) == 1.0
      assert Vector.length_squared({0.0, 2.0, 0.0}) == 4.0
      assert Vector.length_squared({0.0, 0.0, 3.0}) == 9.0
    end
  end


  describe "Raytracer.Geometry.Vector.max_component/1" do
    test "returns the largest component value of a vector" do
      assert Vector.max_component({2.0, 1.0}) == 2.0
      assert Vector.max_component({2.0, 4.0}) == 4.0
      assert Vector.max_component({1.0, 2.0, 3.0}) == 3.0
      assert Vector.max_component({2.0, 4.0, -1.0}) == 4.0
      assert Vector.max_component({5.0, 1.0, -2.0}) == 5.0
    end
  end


  describe "Raytracer.Geometry.Vector.min_component/1" do
    test "returns the smallest component value of a vector" do
      assert Vector.min_component({1.0, 2.0}) == 1.0
      assert Vector.min_component({2.0, 1.0}) == 1.0
      assert Vector.min_component({1.0, 2.0, 3.0}) == 1.0
      assert Vector.min_component({2.0, 4.0, -1.0}) == -1.0
      assert Vector.min_component({5.0, -1.0, 2.0}) == -1.0
    end
  end


  describe "Raytracer.Geometry.Vector.multiply/2" do
    test "multiplies a vector by a scalar value" do
      scalar = 2.0

      assert Vector.multiply({2.0, 4.0}, scalar) == {4.0, 8.0}
      assert Vector.multiply({2.0, 4.0, 6.0}, scalar) == {4.0, 8.0, 12.0}
    end
  end


  describe "Raytracer.Geometry.Vector.negate/1" do
    test "returns the vector pointing in the opposite direction of the given vector" do
      assert Vector.negate({1.0, 2.0}) == {-1.0, -2.0}
      assert Vector.negate({1.0, 2.0, 3.0}) == {-1.0, -2.0, -3.0}
    end
  end


  describe "Raytracer.Geometry.Vector.normalize/1" do
    test "normalizes a vector" do
      assert Vector.normalize({10.0, 0.0}) == {1.0, 0.0}
      assert Vector.normalize({0.0, 8.0}) == {0.0, 1.0}
      assert Vector.normalize({10.0, 0.0, 0.0}) == {1.0, 0.0, 0.0}
      assert Vector.normalize({0.0, 8.0, 0.0}) == {0.0, 1.0, 0.0}
      assert Vector.normalize({0.0, 0.0, 6.0}) == {0.0, 0.0, 1.0}
    end
  end


  describe "Raytracer.Geometry.Vector.subtract/2" do
    test "subtracts two vectors" do
      assert Vector.subtract({1.0, 5.0}, {2.0, 3.0}) == {-1.0, 2.0}
      assert Vector.subtract({1.0, 5.0, 4.0}, {2.0, 3.0, 4.0}) == {-1.0, 2.0, 0.0}
    end
  end
end
