defmodule Raytracer.Geometry.RayTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.Ray
  alias Raytracer.Transform

  describe "Raytracer.Geometry.Ray.apply_transform/2" do
    test "transforms a ray and returns the result" do
      t = Transform.scale({2.0, 3.0, 4.0})
      r = {{2.0, 3.0, 4.0}, {2.0, 3.0, 4.0}}
      expected = {{4.0, 9.0, 16.0}, {4.0, 9.0, 16.0}}

      assert Ray.apply_transform(r, t) == expected
    end
  end

  describe "Raytracer.Geometry.Ray.point_at/2" do
    test "computes the point at a given distance along a ray" do
      r = {{1.0, 0.0, 1.0}, {1.0, 1.0, 1.0}}
      distance = 2.0

      assert Ray.point_at(r, distance) == {3.0, 2.0, 3.0}
    end

    test "raises an error when distance is negative" do
      r = {{1.0, 0.0, 1.0}, {1.0, 1.0, 1.0}}
      distance = -1.0

      assert_raise ArgumentError, fn ->
        Ray.point_at(r, distance)
      end
    end
  end
end
