defmodule Raytracer.Lighting.CookTorranceLightingModelTest do
  use ExUnit.Case, async: true
  alias Raytracer.{ColorRGB, Material, Model, Scene, SurfaceInteraction}
  alias Raytracer.Geometry.{Point3, Vector3}
  alias Raytracer.Lighting.{CookTorranceLightingModel, LightSource, PositionalLight}
  alias Raytracer.Shape.Sphere

  @delta 1.0e-7

  @material %Material{
    diffuse: 0.6,
    specular: 0.4,
    shininess: 0.2,
    reflected_scale_factor: 1.0,
    transmitted_scale_factor: 1.0,
    normal_reflectances: %{
      red: [0.8],
      green: [0.6],
      blue: [0.4]
    }
  }

  @model %Model{
    material: @material,
    shape: %Sphere{center: %Point3{x: 0.0, y: 0.0, z: 0.0}, radius: 1.0}
  }

  @surface_interaction %SurfaceInteraction{
    model: @model,
    normal: %Vector3{dx: -1.0, dy: 0.0, dz: 0.0},
    point: %Point3{x: 1.0, y: 0.0, z: 0.0}
  }

  @scene %Scene{
    light_sources: [
      %LightSource{
        color: %ColorRGB{red: 1.0, green: 1.0, blue: 1.0},
        light: %PositionalLight{
          radius: 0.1,
          position: %Point3{x: -10.0, y: 0.0, z: 0.0}
        }
      }
    ],
    models: [@model]
  }

  @view_direction %Vector3{dx: -1.0, dy: 0.0}

  describe "compute_color/2" do
    test "computes the color for a surface point on a model" do
      color = CookTorranceLightingModel.compute_color(@view_direction, @surface_interaction, @scene)

      assert_in_delta color.red, 0.0056037, @delta
      assert_in_delta color.green, 0.0055726, @delta
      assert_in_delta color.blue, 0.0055414, @delta
    end

    test "returns black if the shape is shadowed" do
      model = %Model{
        material: @material,
        shape: %Sphere{center: %Point3{x: -5.0, y: 0.0, z: 0.0}, radius: 5.0}
      }

      scene = %{@scene | models: @scene.models ++ [model]}

      color = CookTorranceLightingModel.compute_color(@view_direction, @surface_interaction, scene)

      assert color == ColorRGB.black()
    end
  end
end
