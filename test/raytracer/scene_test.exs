defmodule Raytracer.SceneTest do
  use ExUnit.Case, async: true
  use PropCheck
  alias Raytracer.{ColorRGB, Material, Model, Scene}
  alias Raytracer.Geometry.{Point3, Vector3}
  alias Raytracer.Lighting.{DirectionalLight, LightSource, PositionalLight}
  alias Raytracer.Shape.Sphere

  @test_dir "test/support/test_data/"

  doctest Scene

  describe "from_file/1" do
    test "builds a scene from the given file" do
      file = @test_dir <> "test_scene.json"

      assert {:ok, scene} = Scene.from_file(file)

      assert scene.light_sources == [
               %LightSource{
                 color: %ColorRGB{red: 0.5, green: 0.25, blue: 0.1},
                 light: %DirectionalLight{
                   direction: %Vector3{dx: 1.0, dy: -1.0, dz: -0.5},
                   solid_angle: 0.1
                 }
               },
               %LightSource{
                 color: %ColorRGB{red: 1.0, green: 0.0, blue: 0.3},
                 light: %PositionalLight{
                   position: %Point3{x: 1.0, y: 2.0, z: 1.0},
                   radius: 0.5
                 }
               }
             ]

      assert scene.models == [
               %Model{
                 shape: %Sphere{
                   center: %Point3{x: 1.0, y: 2.0, z: 3.0},
                   radius: 4.0
                 },
                 material: %Material{
                   diffuse: 0.6,
                   specular: 0.4,
                   shininess: 0.2,
                   reflected_scale_factor: 0.8,
                   transmitted_scale_factor: 0.1,
                   normal_reflectances: [
                     0.460,
                     0.420,
                     0.410,
                     0.350,
                     0.180,
                     0.080,
                     0.050
                   ]
                 }
               }
             ]
    end
  end
end
