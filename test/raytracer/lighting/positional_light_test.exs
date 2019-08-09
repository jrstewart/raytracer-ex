defmodule Raytracer.Lighting.PositionalLightTest do
  use ExUnit.Case, async: true
  import Raytracer.GeometryTestHelpers
  alias Raytracer.Geometry.{Point3, Vector3}
  alias Raytracer.Lighting.{Light, PositionalLight}

  @delta 1.0e-7

  describe "parse/1" do
    test "parses the light data from the given map" do
      data = %{"position" => [1.0, 2.0, 3.0], "radius" => 4.0}
      assert {:ok, light} = PositionalLight.parse(data)
      assert light.position == %Point3{x: 1.0, y: 2.0, z: 3.0}
      assert light.radius == 4.0
    end

    test "returns an error if parsing failed" do
      data = %{"radius" => 2.0}
      assert {:error, message} = PositionalLight.parse(data)
      assert message == "error parsing positional light"
    end
  end

  describe "compute_direction/2" do
    test "returns the normalized vector pointing in the direction of the light source" do
      light = %PositionalLight{position: %Point3{x: 1.0, y: 1.0, z: 1.0}, radius: 2.0}
      point = %Point3{x: -1.0, y: -1.0, z: -1.0}

      assert_equal_within_delta Light.compute_direction(light, point),
                                %Vector3{dx: 0.5773502, dy: 0.5773502, dz: 0.5773502}
    end
  end

  describe "compute_solid_angle/2" do
    test "returns the solid angle between the light and the surface point" do
      light = %PositionalLight{position: %Point3{x: 1.0, y: 1.0, z: 1.0}, radius: 2.0}
      point = %Point3{x: 0.0, y: 0.0, z: 0.0}
      assert_in_delta Light.compute_solid_angle(light, point), 4.1887902, @delta
    end
  end
end
