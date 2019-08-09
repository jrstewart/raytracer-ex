defmodule Raytracer.Lighting.DirectionalLightTest do
  use ExUnit.Case, async: true
  alias Raytracer.Geometry.{Point3, Vector3}
  alias Raytracer.Lighting.{Light, DirectionalLight}

  describe "parse/1" do
    test "parses the light data from the given map" do
      data = %{"direction" => [1.0, 2.0, 3.0], "solid_angle" => 4.0}
      assert {:ok, light} = DirectionalLight.parse(data)
      assert light.direction == %Vector3{dx: 1.0, dy: 2.0, dz: 3.0}
      assert light.solid_angle == 4.0
    end

    test "returns an error if parsing failed" do
      data = %{"radius" => 2.0}
      assert {:error, message} = DirectionalLight.parse(data)
      assert message == "error parsing directional light"
    end
  end

  describe "compute_direction/2" do
    test "returns the direction of the light source" do
      direction = %Vector3{dx: 1.0, dy: 0.0, dz: 1.0}
      light = %DirectionalLight{direction: direction, solid_angle: 2.0}
      point = %Point3{x: -1.0, y: -1.0, z: -1.0}
      assert Light.compute_direction(light, point) == direction
    end
  end

  describe "compute_solid_angle/2" do
    test "returns the solid angle between the light and the surface point" do
      solid_angle = 2.0

      light = %DirectionalLight{
        direction: %Vector3{dx: 1.0, dy: 0.0, dz: 1.0},
        solid_angle: solid_angle
      }

      point = %Point3{x: 0.0, y: 0.0, z: 0.0}
      assert Light.compute_solid_angle(light, point) == solid_angle
    end
  end
end
