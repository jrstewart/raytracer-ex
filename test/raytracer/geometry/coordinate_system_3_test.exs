defmodule Raytracer.Geometry.CoordinateSystem3Test do
  use ExUnit.Case, async: true
  alias Raytracer.Geometry.{CoordinateSystem3, Vector3}

  describe "Raytracer.Geometry.CoordinateSystem3.create_from_vector/1" do
    test "creates a coordinate system from a vector" do
      c = CoordinateSystem3.create_from_vector(%Vector3{dx: 0.0, dy: 0.0, dz: 2.0})

      assert c.u_axis == %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
      assert c.v_axis == %Vector3{dx: 0.0, dy: 1.0, dz: 0.0}
      assert c.w_axis == %Vector3{dx: -1.0, dy: 0.0, dz: 0.0}
    end
  end

  describe "Raytracer.Geometry.CoordinateSystem3.create_from_normalized_vector/1" do
    test "creates a coordinate system from a vector" do
      c = CoordinateSystem3.create_from_normalized_vector(%Vector3{dx: 0.0, dy: 0.0, dz: 1.0})

      assert c.u_axis == %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
      assert c.v_axis == %Vector3{dx: 0.0, dy: 1.0, dz: 0.0}
      assert c.w_axis == %Vector3{dx: -1.0, dy: 0.0, dz: 0.0}
    end

    test "creates a coordinate system from a vector with dx larger than dy" do
      c = CoordinateSystem3.create_from_normalized_vector(%Vector3{dx: 1.0, dy: 0.0, dz: 0.0})

      assert c.u_axis == %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}
      assert c.v_axis == %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
      assert c.w_axis == %Vector3{dx: 0.0, dy: -1.0, dz: 0.0}
    end
  end
end
