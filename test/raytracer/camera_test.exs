defmodule Raytracer.CameraTest do
  use ExUnit.Case, async: true
  alias Raytracer.Camera
  alias Raytracer.Geometry.{Point3, Vector3}

  @delta 1.0e-7

  describe "pixel_grid/1" do
    test "returns the grid of the camera" do
      camera = %Camera{
        center: %Point3{x: 0.0, y: 0.0, z: 0.0},
        distance: 10.0,
        eye: %Point3{x: 0.0, y: 0.0, z: 10.0},
        height: 4,
        width: 5,
        world_coordinates_window: {-10.0, 10.0, -10.0, 10.0},
        up: %Vector3{dx: 0.0, dy: 1.0, dz: 0.0}
      }

      grid = Camera.pixel_grid(camera)

      assert length(grid) == camera.width * camera.height

      assert grid == [
               %Point3{x: -8.0, y: -7.5, z: 0.0},
               %Point3{x: -4.0, y: -7.5, z: 0.0},
               %Point3{x: 0.0, y: -7.5, z: 0.0},
               %Point3{x: 4.0, y: -7.5, z: 0.0},
               %Point3{x: 8.0, y: -7.5, z: 0.0},
               %Point3{x: -8.0, y: -2.5, z: 0.0},
               %Point3{x: -4.0, y: -2.5, z: 0.0},
               %Point3{x: 0.0, y: -2.5, z: 0.0},
               %Point3{x: 4.0, y: -2.5, z: 0.0},
               %Point3{x: 8.0, y: -2.5, z: 0.0},
               %Point3{x: -8.0, y: 2.5, z: 0.0},
               %Point3{x: -4.0, y: 2.5, z: 0.0},
               %Point3{x: 0.0, y: 2.5, z: 0.0},
               %Point3{x: 4.0, y: 2.5, z: 0.0},
               %Point3{x: 8.0, y: 2.5, z: 0.0},
               %Point3{x: -8.0, y: 7.5, z: 0.0},
               %Point3{x: -4.0, y: 7.5, z: 0.0},
               %Point3{x: 0.0, y: 7.5, z: 0.0},
               %Point3{x: 4.0, y: 7.5, z: 0.0},
               %Point3{x: 8.0, y: 7.5, z: 0.0}
             ]
    end
  end

  describe "pixel_size/1" do
    test "returns the pixel size of the camera pixels" do
      camera = %Camera{
        center: %Point3{x: 0.0, y: 0.0, z: 0.0},
        distance: 10.0,
        eye: %Point3{x: 0.0, y: 0.0, z: 10.0},
        height: 75,
        width: 50,
        world_coordinates_window: {-10.0, 10.0, -20.0, 20.0},
        up: %Vector3{dx: 0.0, dy: 1.0, dz: 0.0}
      }

      {width, height} = Camera.pixel_size(camera)

      assert_in_delta width, 0.4, @delta
      assert_in_delta height, 0.5333333, @delta
    end
  end
end
