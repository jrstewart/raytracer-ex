defmodule Raytracer.RayDifferentialTest do
  use ExUnit.Case, async: true

  alias Raytracer.Ray
  alias Raytracer.RayDifferential
  alias Raytracer.Point3
  alias Raytracer.Vector3

  describe "Raytracer.RayDifferential.scale/2" do
    test "scales the ray differential based on the given scalar value" do
      rd = %RayDifferential{
        ray: %Ray{
          origin: %Point3{x: 1.0, y: 1.0, z: 1.0},
          direction: %Vector3{dx: 1.0, dy: 1.0, dz: 1.0},
        },
        x_origin: %Point3{x: 2.0, y: 2.0, z: 2.0},
        y_origin: %Point3{x: -2.0, y: -2.0, z: -2.0},
        x_direction: %Vector3{dx: 2.0, dy: 2.0, dz: 2.0},
        y_direction: %Vector3{dx: -2.0, dy: -2.0, dz: -2.0},
      }
      scalar = 2.0

      scaled_rd = RayDifferential.scale(rd, scalar)

      assert scaled_rd.x_origin == %Point3{x: 3.0, y: 3.0, z: 3.0}
      assert scaled_rd.y_origin == %Point3{x: -5.0, y: -5.0, z: -5.0}
      assert scaled_rd.x_direction == %Vector3{dx: 3.0, dy: 3.0, dz: 3.0}
      assert scaled_rd.y_direction == %Vector3{dx: -5.0, dy: -5.0, dz: -5.0}
    end
  end
end
