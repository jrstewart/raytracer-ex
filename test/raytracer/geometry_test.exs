defmodule Raytracer.GeometryTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry

  describe "Raytracer.Geometry.lerp/3" do
    test "linearly interpolates between two values" do
      assert Geometry.lerp(0.0, 2.0, 0.5) == 1.0
      assert Geometry.lerp(0.0, 2.0, 0.0) == 0.0
      assert Geometry.lerp(0.0, 2.0, 1.0) == 2.0
    end
  end
end
