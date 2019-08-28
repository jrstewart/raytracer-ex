defmodule Raytracer.Shape.PhongTriangleTest do
  use ExUnit.Case, async: true
  alias Raytracer.Shape
  alias Raytracer.Geometry.{Point3, Ray3, Vector3}
  alias Raytracer.Shape.PhongTriangle

  @triangle %PhongTriangle{
    vertex1: %Point3{x: 0.0, y: 0.0, z: 0.0},
    normal1: %Vector3{dx: 0.0, dy: 0.0, dz: 1.0},
    vertex2: %Point3{x: 2.0, y: 0.0, z: 0.0},
    normal2: %Vector3{dx: 0.0, dy: 0.0, dz: 1.0},
    vertex3: %Point3{x: 1.0, y: 2.0, z: 0.0},
    normal3: %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
  }

  describe "parse/1" do
    test "parses the triangle data from the given map" do
      data = %{
        "vertices" => [
          [1.0, 2.0, 3.0],
          [4.0, 5.0, 6.0],
          [7.0, 8.0, 9.0]
        ],
        "normals" => [
          [2.0, 0.0, 0.0],
          [0.0, 2.0, 0.0],
          [0.0, 0.0, 2.0]
        ]
      }

      assert {:ok, triangle} = PhongTriangle.parse(data)
      assert triangle.vertex1 == %Point3{x: 1.0, y: 2.0, z: 3.0}
      assert triangle.vertex2 == %Point3{x: 4.0, y: 5.0, z: 6.0}
      assert triangle.vertex3 == %Point3{x: 7.0, y: 8.0, z: 9.0}
    end

    test "returns an error if parsing failed" do
      data = %{"vertices" => []}

      assert {:error, message} = PhongTriangle.parse(data)
      assert message == "error parsing triangle"
    end
  end

  describe "compute_intersection/2" do
    test "returns nil when no intersection exists" do
      ray = %Ray3{
        origin: %Point3{x: 0.0, y: 0.0, z: 0.0},
        direction: %Vector3{dx: 0.0, dy: 1.0, dz: 0.0}
      }

      assert Shape.compute_intersection(@triangle, ray) == nil

      ray = %Ray3{
        origin: %Point3{x: 5.0, y: 5.0, z: -1.0},
        direction: %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
      }

      assert Shape.compute_intersection(@triangle, ray) == nil
    end

    test "computes the intersection distance of a sphere and a ray" do
      ray = %Ray3{
        origin: %Point3{x: 1.0, y: 1.0, z: -1.0},
        direction: %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
      }

      assert Shape.compute_intersection(@triangle, ray) == 1.0
    end
  end

  describe "compute_outward_normal/2" do
    test "computes the outward pointing normal at a point on a sphere" do
      point = %Point3{x: 1.0, y: 1.0, z: 0.0}

      assert Shape.compute_outward_normal(@triangle, point) == %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
    end
  end

  describe "compute_inward_normal/2" do
    test "computes the inward pointing normal at a point on a sphere" do
      point = %Point3{x: 1.0, y: 1.0, z: 0.0}

      assert Shape.compute_inward_normal(@triangle, point) == %Vector3{dx: 0.0, dy: 0.0, dz: -1.0}
    end
  end
end
