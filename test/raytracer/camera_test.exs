defmodule Raytracer.CameraTest do
  use ExUnit.Case, async: true
  alias Raytracer.Camera
  alias Raytracer.Geometry.{CoordinateSystem3, Point3, Vector3}

  @delta 1.0e-7

  describe "parse/1" do
    test "parses the camera data from the given map" do
      data = %{
        "center" => [-10.0, 0.0, 0.0],
        "distance" => 50.0,
        "eye" => [0.0, 0.0, 0.0],
        "height" => 256,
        "width" => 512,
        "wc_window" => [-10.0, 10.0, -20.0, 20.0],
        "up" => [0.0, 2.0, 0.0]
      }

      assert {:ok, camera} = Camera.parse(data)
      assert camera.distance == 50.0
      assert camera.eye == %Point3{x: 0.0, y: 0.0, z: 0.0}
      assert camera.height == 256
      assert camera.width == 512
      assert camera.wc_window.u_min == -10.0
      assert camera.wc_window.u_max == 10.0
      assert camera.wc_window.v_min == -20.0
      assert camera.wc_window.v_max == 20.0

      assert camera.coords == %CoordinateSystem3{
               u_axis: %Vector3{dx: 0.0, dy: 0.0, dz: -1.0},
               v_axis: %Vector3{dx: 0.0, dy: 1.0, dz: 0.0},
               w_axis: %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}
             }
    end

    test "returns an error if parsing failed" do
      data = %{"distance" => 20.0}
      assert {:error, message} = Camera.parse(data)
      assert message == "error parsing camera"
    end
  end

  describe "pixel_grid/1" do
    test "returns the grid of the camera" do
      camera = %Camera{
        coords: %CoordinateSystem3{
          u_axis: %Vector3{dx: 1.0, dy: 0.0, dz: 0.0},
          v_axis: %Vector3{dx: 0.0, dy: 1.0, dz: 0.0},
          w_axis: %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
        },
        distance: 10.0,
        eye: %Point3{x: 0.0, y: 0.0, z: 10.0},
        height: 4,
        width: 5,
        wc_window: %{u_min: -10.0, u_max: 10.0, v_min: -10.0, v_max: 10.0}
      }

      grid = Camera.pixel_grid(camera)

      assert length(grid) == camera.width * camera.height

      assert grid == [
               %Point3{x: -10.0, y: -10.0, z: 0.0},
               %Point3{x: -6.0, y: -10.0, z: 0.0},
               %Point3{x: -2.0, y: -10.0, z: 0.0},
               %Point3{x: 2.0, y: -10.0, z: 0.0},
               %Point3{x: 6.0, y: -10.0, z: 0.0},
               %Point3{x: -10.0, y: -5.0, z: 0.0},
               %Point3{x: -6.0, y: -5.0, z: 0.0},
               %Point3{x: -2.0, y: -5.0, z: 0.0},
               %Point3{x: 2.0, y: -5.0, z: 0.0},
               %Point3{x: 6.0, y: -5.0, z: 0.0},
               %Point3{x: -10.0, y: 0.0, z: 0.0},
               %Point3{x: -6.0, y: 0.0, z: 0.0},
               %Point3{x: -2.0, y: 0.0, z: 0.0},
               %Point3{x: 2.0, y: 0.0, z: 0.0},
               %Point3{x: 6.0, y: 0.0, z: 0.0},
               %Point3{x: -10.0, y: 5.0, z: 0.0},
               %Point3{x: -6.0, y: 5.0, z: 0.0},
               %Point3{x: -2.0, y: 5.0, z: 0.0},
               %Point3{x: 2.0, y: 5.0, z: 0.0},
               %Point3{x: 6.0, y: 5.0, z: 0.0}
             ]
    end
  end

  describe "pixel_size/1" do
    test "returns the pixel size of the camera pixels" do
      camera = %Camera{
        coords: %CoordinateSystem3{
          u_axis: %Vector3{dx: 1.0, dy: 0.0, dz: 0.0},
          v_axis: %Vector3{dx: 0.0, dy: 1.0, dz: 0.0},
          w_axis: %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
        },
        distance: 10.0,
        eye: %Point3{x: 0.0, y: 0.0, z: 10.0},
        height: 75,
        width: 50,
        wc_window: %{u_min: -10.0, u_max: 10.0, v_min: -20.0, v_max: 20.0}
      }

      {width, height} = Camera.pixel_size(camera)

      assert_in_delta width, 0.4, @delta
      assert_in_delta height, 0.5333333, @delta
    end
  end
end
