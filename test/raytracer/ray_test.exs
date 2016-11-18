defmodule Raytracer.RayTest do
  use ExUnit.Case, async: true

  alias Raytracer.Ray
  alias Raytracer.Point3
  alias Raytracer.Vector3

  describe "Raytracer.Ray.point_at/2" do
    test "computes the point at a given distance along a ray" do
      r = %Ray{
        origin: %Point3{x: 1.0, y: 0.0, z: 1.0},
        direction: %Vector3{dx: 1.0, dy: 1.0, dz: 1.0},
      }
      distance = 2.0

      assert Ray.point_at(r, distance) == %Point3{x: 3.0, y: 2.0, z: 3.0}
    end

    test "raises an error when distance is negative" do
      r = %Ray{
        origin: %Point3{x: 1.0, y: 0.0, z: 1.0},
        direction: %Vector3{dx: 1.0, dy: 1.0, dz: 1.0},
      }
      distance = -1.0

      assert_raise ArgumentError, fn ->
        Ray.point_at(r, distance)
      end
    end
  end
end
