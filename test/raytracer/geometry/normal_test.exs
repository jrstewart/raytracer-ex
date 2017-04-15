defmodule Raytracer.Geometry.NormalTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.Normal
  alias Raytracer.Transform

  describe "Raytracer.Geometry.Normal.abs/1" do
    test "returns the normal with the absolute value of each component" do
      assert Normal.abs({-1.0, -2.0, -3.0}) == {1.0, 2.0, 3.0}
    end
  end

  describe "Raytracer.Geometry.Normal.add/2" do
    test "adds two normals" do
      assert Normal.add({1.0, 2.0, 3.0}, {4.0, 5.0, 6.0}) == {5.0, 7.0, 9.0}
    end
  end

  describe "Raytracer.Geometry.Normal.apply_transform/2" do
    test "transforms a normal and returns the result" do
      t = Transform.translate({2.0, 3.0, 4.0})
      n = {2.0, 3.0, 4.0}

      assert Normal.apply_transform(n, t) == {2.0, 3.0, 4.0}

      t = Transform.scale({2.0, 3.0, 4.0})
      n = {2.0, 3.0, 4.0}

      assert Normal.apply_transform(n, t) == {1.0, 1.0, 1.0}
    end
  end

  describe "Raytracer.Geometry.Normal.cross/2" do
    test "computes the cross product of a normal and a vector" do
      assert Normal.cross({2.0, 3.0, 4.0}, {5.0, 6.0, 7.0}) == {-3.0, 6.0, -3.0}
    end
  end

  describe "Raytracer.Geometry.Normal.divide/2" do
    test "divides a normal by a scalar value" do
      assert Normal.divide({2.0, 4.0, 6.0}, 2.0) == {1.0, 2.0, 3.0}
    end
  end

  describe "Raytracer.Geometry.Normal.dot/2" do
    test "computes the dot product of two normals" do
      assert Normal.dot({1.0, 1.0, 1.0}, {2.0, 2.0, 2.0}) == 6.0
    end
  end

  describe "Raytracer.Geometry.Normal.length/1" do
    test "computes the length of a normal" do
      assert Normal.length({1.0, 0.0, 0.0}) == 1.0
      assert Normal.length({0.0, 2.0, 0.0}) == 2.0
      assert Normal.length({0.0, 0.0, 3.0}) == 3.0
    end
  end

  describe "Raytracer.Geometry.Normal.length_squared/1" do
    test "computes the squared length of a normal" do
      assert Normal.length_squared({1.0, 0.0, 0.0}) == 1.0
      assert Normal.length_squared({0.0, 2.0, 0.0}) == 4.0
      assert Normal.length_squared({0.0, 0.0, 3.0}) == 9.0
    end
  end

  describe "Raytracer.Geometry.Normal.multiply/2" do
    test "multiplies a normal by a scalar value" do
      assert Normal.multiply({2.0, 4.0, 6.0}, 2.0) == {4.0, 8.0, 12.0}
    end
  end

  describe "Raytracer.Geometry.Normal.negate/1" do
    test "returns the normal pointing in the opposite direction of the given normal" do
      assert Normal.negate({1.0, 2.0, 3.0}) == {-1.0, -2.0, -3.0}
    end
  end

  describe "Raytracer.Geometry.Normal.normalize/1" do
    test "normalizes a normal" do
      assert Normal.normalize({10.0, 0.0, 0.0}) == {1.0, 0.0, 0.0}
      assert Normal.normalize({0.0, 8.0, 0.0}) == {0.0, 1.0, 0.0}
      assert Normal.normalize({0.0, 0.0, 6.0}) == {0.0, 0.0, 1.0}
    end
  end

  describe "Raytracer.Geometry.Normal.subtract/2" do
    test "subtracts two normals" do
      assert Normal.subtract({1.0, 5.0, 4.0}, {2.0, 3.0, 4.0}) == {-1.0, 2.0, 0.0}
    end
  end
end
