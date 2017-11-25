defmodule Raytracer.Geometry.Ray3DifferentialTest do
  use ExUnit.Case, async: true

  alias Raytracer.{Transform, Transformable}
  alias Raytracer.Geometry.{Point3, Ray3, Ray3Differential, Vector3}

  describe "Raytracer.Geometry.Ray3Differential.scale/2" do
    test "scales the ray differential based on the given scalar value" do
      ray_differential = %Ray3Differential{
        ray: %Ray3{
          origin: %Point3{x: 1.0, y: 1.0, z: 1.0},
          direction: %Vector3{dx: 1.0, dy: 1.0, dz: 1.0}
        },
        x_origin: %Point3{x: 2.0, y: 2.0, z: 2.0},
        y_origin: %Point3{x: -2.0, y: -2.0, z: -2.0},
        x_direction: %Vector3{dx: 2.0, dy: 2.0, dz: 2.0},
        y_direction: %Vector3{dx: -2.0, dy: -2.0, dz: -2.0}
      }

      scalar = 2.0

      result = Ray3Differential.scale(ray_differential, scalar)

      assert result.x_origin == %Point3{x: 3.0, y: 3.0, z: 3.0}
      assert result.y_origin == %Point3{x: -5.0, y: -5.0, z: -5.0}
      assert result.x_direction == %Vector3{dx: 3.0, dy: 3.0, dz: 3.0}
      assert result.y_direction == %Vector3{dx: -5.0, dy: -5.0, dz: -5.0}
    end
  end

  describe "Raytracer.Transformable.apply_transform/2" do
    test "transforms a ray differential and returns the result" do
      transform = Transform.scale({2.0, 3.0, 4.0})

      ray_differential = %Ray3Differential{
        ray: %Ray3{
          origin: %Point3{x: 1.0, y: 1.0, z: 1.0},
          direction: %Vector3{dx: -1.0, dy: -1.0, dz: -1.0}
        },
        x_origin: %Point3{x: 2.0, y: 2.0, z: 2.0},
        y_origin: %Point3{x: -2.0, y: -2.0, z: -2.0},
        x_direction: %Vector3{dx: 3.0, dy: 3.0, dz: 3.0},
        y_direction: %Vector3{dx: -3.0, dy: -3.0, dz: -3.0}
      }

      result = Transformable.apply_transform(ray_differential, transform)

      assert result.ray == %Ray3{
               origin: %Point3{x: 2.0, y: 3.0, z: 4.0},
               direction: %Vector3{dx: -2.0, dy: -3.0, dz: -4.0}
             }

      assert result.x_origin == %Point3{x: 4.0, y: 6.0, z: 8.0}
      assert result.y_origin == %Point3{x: -4.0, y: -6.0, z: -8.0}
      assert result.x_direction == %Vector3{dx: 6.0, dy: 9.0, dz: 12.0}
      assert result.y_direction == %Vector3{dx: -6.0, dy: -9.0, dz: -12.0}
    end
  end
end
