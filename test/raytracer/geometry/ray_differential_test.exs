defmodule Raytracer.Geometry.RayDifferentialTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.RayDifferential
  alias Raytracer.Transform

  describe "Raytracer.Geometry.RayDifferential.apply_transform/2" do
    test "transforms a ray differential and returns the result" do
      t = Transform.scale({2.0, 3.0, 4.0})
      rd = %RayDifferential{ray: {{1.0, 1.0, 1.0}, {-1.0, -1.0, -1.0}},
                            x_origin: {2.0, 2.0, 2.0},
                            y_origin: {-2.0, -2.0, -2.0},
                            x_direction: {3.0, 3.0, 3.0},
                            y_direction: {-3.0, -3.0, -3.0}}

      new_rd = RayDifferential.apply_transform(rd, t)

      assert new_rd.ray == {{2.0, 3.0, 4.0}, {-2.0, -3.0, -4.0}}
      assert new_rd.x_origin == {4.0, 6.0, 8.0}
      assert new_rd.y_origin == {-4.0, -6.0, -8.0}
      assert new_rd.x_direction == {6.0, 9.0, 12.0}
      assert new_rd.y_direction == {-6.0, -9.0, -12.0}
    end
  end

  describe "Raytracer.Geometry.RayDifferential.scale/2" do
    test "scales the ray differential based on the given scalar value" do
      rd = %RayDifferential{ray: {{1.0, 1.0, 1.0}, {1.0, 1.0, 1.0}},
                            x_origin: {2.0, 2.0, 2.0},
                            y_origin: {-2.0, -2.0, -2.0},
                            x_direction: {2.0, 2.0, 2.0},
                            y_direction: {-2.0, -2.0, -2.0}}
      scalar = 2.0

      new_rd = RayDifferential.scale(rd, scalar)

      assert new_rd.x_origin == {3.0, 3.0, 3.0}
      assert new_rd.y_origin == {-5.0, -5.0, -5.0}
      assert new_rd.x_direction == {3.0, 3.0, 3.0}
      assert new_rd.y_direction == {-5.0, -5.0, -5.0}
    end
  end
end
