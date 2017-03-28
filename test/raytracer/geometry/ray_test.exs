defmodule Raytracer.Geometry.RayTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.Ray


  describe "Raytracer.Geometry.Ray.point_at/2" do
    test "computes the point at a given distance along a ray" do
      r = %Ray{
        origin: {1.0, 0.0, 1.0},
        direction: {1.0, 1.0, 1.0},
      }
      distance = 2.0

      assert Ray.point_at(r, distance) == {3.0, 2.0, 3.0}
    end

    test "raises an error when distance is negative" do
      r = %Ray{
        origin: {1.0, 0.0, 1.0},
        direction: {1.0, 1.0, 1.0},
      }
      distance = -1.0

      assert_raise ArgumentError, fn ->
        Ray.point_at(r, distance)
      end
    end
  end
end
