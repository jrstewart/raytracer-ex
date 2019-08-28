defmodule Raytracer.ModelTest do
  use ExUnit.Case, async: true
  alias Raytracer.{Material, Model}
  alias Raytracer.Shape.{PhongTriangle, Sphere}

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
      assert %Sphere{} = model.shape
      assert %Material{} = model.material
    end

    test "parses a triangle model" do
      data = %{
        "type" => "triangle",
        "data" => %{
          "vertices" => [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [1.0, 1.0, 0.0]],
          "normals" => [[0.0, 0.0, 1.0], [0.0, 0.0, 1.0], [0.0, 0.0, 1.0]]
        },
        "material" => @material
      }

      assert {:ok, model} = Model.parse(data)
      assert %PhongTriangle{} = model.shape
      assert %Material{} = model.material
    end
  end
end
