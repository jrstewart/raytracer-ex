defmodule Raytracer.Geometry.CoordinateSystemTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.CoordinateSystem


  describe "Raytracer.Geometry.CoordinateSystem.create_from_vector/1" do
    test "creates a coordinate system from a vector" do
      c = CoordinateSystem.create_from_vector({0.0, 0.0, 2.0})

      assert c.u_axis == {0.0, 0.0, 1.0}
      assert c.v_axis == {0.0, 1.0, 0.0}
      assert c.w_axis == {-1.0, 0.0, 0.0}
    end
  end


  describe "Raytracer.Geometry.CoordinateSystem.create_from_normalized_vector/1" do
    test "creates a coordinate system from a vector" do
      c = CoordinateSystem.create_from_normalized_vector({0.0, 0.0, 1.0})

      assert c.u_axis == {0.0, 0.0, 1.0}
      assert c.v_axis == {0.0, 1.0, 0.0}
      assert c.w_axis == {-1.0, 0.0, 0.0}
    end

    test "creates a coordinate system from a vector with dx larger than dy" do
      c = CoordinateSystem.create_from_normalized_vector({1.0, 0.0, 0.0})

      assert c.u_axis == {1.0, 0.0, 0.0}
      assert c.v_axis == {0.0, 0.0, 1.0}
      assert c.w_axis == {0.0, -1.0, 0.0}
    end
  end
end
