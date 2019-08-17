defmodule Raytracer.Lighting.LightSourceTest do
  use ExUnit.Case, async: true
  alias Raytracer.ColorRGB
  alias Raytracer.Geometry.{Point3, Vector3}
  alias Raytracer.Lighting.LightSource

  describe "parse/1" do
    test "parses a positional light source" do
      data = %{
        "type" => "positional",
        "data" => %{"position" => [1.0, 2.0, 3.0], "radius" => 4.0},
        "color" => [1.0, 0.5, 0.25]
      }

      assert {:ok, light_source} = LightSource.parse(data)
      assert light_source.light.position == %Point3{x: 1.0, y: 2.0, z: 3.0}
      assert light_source.light.radius == 4.0
      assert light_source.color == %ColorRGB{red: 1.0, green: 0.5, blue: 0.25}
    end

    test "parses a directional light source" do
      data = %{
        "type" => "directional",
        "data" => %{"direction" => [1.0, 0.0, 0.0], "solid_angle" => 2.0},
        "color" => [1.0, 0.5, 0.25]
      }

      assert {:ok, light_source} = LightSource.parse(data)
      assert light_source.light.direction == %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}
      assert light_source.light.solid_angle == 2.0
      assert light_source.color == %ColorRGB{red: 1.0, green: 0.5, blue: 0.25}
    end

    test "returns an error if parsing failed" do
      data = %{"radius" => 2.0}
      assert {:error, message} = LightSource.parse(data)
      assert message == "error parsing light source data"
    end
  end
end
