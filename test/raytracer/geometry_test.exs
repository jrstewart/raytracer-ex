defmodule Raytracer.GeometryTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry


  describe "Raytracer.Geometry.clamp/3" do
    test "returns min_value if value is less than min_value" do
      assert Geometry.clamp(-1.0, 0.0, 3.0) == 0.0
    end

    test "returns max_value if value is greater than max_value" do
      assert Geometry.clamp(4.0, 0.0, 3.0) == 3.0
    end

    test "returns value if value is within min_value and max_value" do
      assert Geometry.clamp(2.0, 0.0, 3.0) == 2.0
    end
  end


  describe "Raytracer.Geometry.degrees_to_radians/1" do
    test "converts an angle in degrees to radians" do
      assert Geometry.degrees_to_radians(180.0) == :math.pi()
    end
  end


  describe "Raytracer.Geometry.lerp/3" do
    test "linearly interpolates between two values" do
      assert Geometry.lerp(0.0, 2.0, 0.5) == 1.0
      assert Geometry.lerp(0.0, 2.0, 0.0) == 0.0
      assert Geometry.lerp(0.0, 2.0, 1.0) == 2.0
    end
  end


  describe "Raytracer.Geometry.radians_to_degrees/1" do
    test "converts an angle in radians to degrees" do
      assert Geometry.radians_to_degrees(:math.pi()) == 180.0
    end
  end
end
