defmodule Raytracer.Geometry.Vector3Test do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.Vector3

  describe "Raytracer.Geometry.Vector3.length/1" do
    test "computes the length of a vector" do
      vector = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}

      assert_in_delta Vector3.length(vector), 3.7416573, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Vector3.length_squared/1" do
    test "computes the squared length of a vector" do
      vector = %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}

      assert_in_delta Vector3.length_squared(vector), 14.0, 1.0e-7
    end
  end
end
