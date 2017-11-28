defmodule Raytracer.Geometry.Ray3Test do
  use ExUnit.Case, async: true

  alias Raytracer.{Transform, Transformable}
  alias Raytracer.Geometry.{Ray3, Point3, Vector3}

  describe "Raytracer.Geometry.Ray3.point_at/2" do
    test "computes the point at a given distance along a ray" do
      ray = %Ray3{
        origin: %Point3{x: 1.0, y: 0.0, z: 1.0},
        direction: %Vector3{dx: 1.0, dy: 1.0, dz: 1.0}
      }

      distance = 2.0
      expected = %Point3{x: 3.0, y: 2.0, z: 3.0}

      assert Ray3.point_at(ray, distance) == {:ok, expected}
    end

    test "returns an error when the distance is negative" do
      ray = %Ray3{
        origin: %Point3{x: 1.0, y: 0.0, z: 1.0},
        direction: %Vector3{dx: 1.0, dy: 1.0, dz: 1.0}
      }

      distance = -1.0

      assert Ray3.point_at(ray, distance) == {:error, :none}
    end
  end

  describe "Raytracer.Transformable.apply_transform/2" do
    test "transforms a ray and returns the result" do
      transform = Transform.scale(2.0, 3.0, 4.0)

      ray = %Ray3{
        origin: %Point3{x: 2.0, y: 3.0, z: 4.0},
        direction: %Vector3{dx: 2.0, dy: 3.0, dz: 4.0}
      }

      expected = %Ray3{
        origin: %Point3{x: 4.0, y: 9.0, z: 16.0},
        direction: %Vector3{dx: 4.0, dy: 9.0, dz: 16.0}
      }

      assert Transformable.apply_transform(ray, transform) == expected
    end
  end
end
