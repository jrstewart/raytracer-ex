defmodule Raytracer.ModelTest do
  use ExUnit.Case, async: true
  alias Raytracer.Model
  alias Raytracer.Shape.Sphere
  alias Raytracer.Geometry.Point3

  @material %{
    "diffuse" => 0.6,
    "specular" => 0.4,
    "shininess" => 0.2,
    "reflected_scale_factor" => 0.8,
    "transmitted_scale_factor" => 0.1,
    "normal_reflectances" => [
      0.460,
      0.420,
      0.410,
      0.350,
      0.180,
      0.080,
      0.050
    ]
  }

  describe "parse/1" do
    test "parses a sphere model" do
      data = %{
        "type" => "sphere",
        "data" => %{
          "center" => [1.0, 2.0, 3.0],
          "radius" => 4.0
        },
        "material" => @material
      }

      assert {:ok, model} = Model.parse(data)
      assert model.shape == %Sphere{center: %Point3{x: 1.0, y: 2.0, z: 3.0}, radius: 4.0}
    end

    test "parses material data" do
      data = %{
        "type" => "sphere",
        "data" => %{
          "center" => [1.0, 2.0, 3.0],
          "radius" => 4.0
        },
        "material" => @material
      }

      assert {:ok, model} = Model.parse(data)
      assert model.material.diffuse == 0.6
      assert model.material.specular == 0.4
      assert model.material.shininess == 0.2
      assert model.material.reflected_scale_factor == 0.8
      assert model.material.transmitted_scale_factor == 0.1

      assert model.material.normal_reflectances == [
               0.460,
               0.420,
               0.410,
               0.350,
               0.180,
               0.080,
               0.050
             ]
    end
  end
end
