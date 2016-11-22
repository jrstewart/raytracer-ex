defmodule Raytracer.Geometry.RayDifferentialTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.{Ray, RayDifferential}

  describe "Raytracer.Geometry.RayDifferential.scale/2" do
    test "scales the ray differential based on the given scalar value" do
      rd = %RayDifferential{
        ray: %Ray{
          origin: {1.0, 1.0, 1.0},
          direction: {1.0, 1.0, 1.0},
        },
        x_origin: {2.0, 2.0, 2.0},
        y_origin: {-2.0, -2.0, -2.0},
        x_direction: {2.0, 2.0, 2.0},
        y_direction: {-2.0, -2.0, -2.0},
      }
      scalar = 2.0

      scaled_rd = RayDifferential.scale(rd, scalar)

      assert scaled_rd.x_origin == {3.0, 3.0, 3.0}
      assert scaled_rd.y_origin == {-5.0, -5.0, -5.0}
      assert scaled_rd.x_direction == {3.0, 3.0, 3.0}
      assert scaled_rd.y_direction == {-5.0, -5.0, -5.0}
    end
  end
end
