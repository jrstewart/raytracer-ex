defmodule Raytracer.CoordinateSystem3Test do
  use ExUnit.Case, async: true

  alias Raytracer.CoordinateSystem3
  alias Raytracer.Vector3

  describe "Raytracer.CoordinateSystem3.create_from_vector/1" do
    test "creates a coordinate system from a vector" do
      v = %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}

      c = CoordinateSystem3.create_from_vector(v)

      assert c.u_axis == %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
      assert c.v_axis == %Vector3{dx: 0.0, dy: 1.0, dz: 0.0}
      assert c.w_axis == %Vector3{dx: -1.0, dy: 0.0, dz: 0.0}
    end

    test "creates a coordinate system from a vector with dx larger than dy" do
      v = %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}

      c = CoordinateSystem3.create_from_vector(v)

      assert c.u_axis == %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}
      assert c.v_axis == %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
      assert c.w_axis == %Vector3{dx: 0.0, dy: -1.0, dz: 0.0}
    end
  end
end
