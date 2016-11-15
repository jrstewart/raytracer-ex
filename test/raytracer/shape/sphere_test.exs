defmodule Raytracer.Shape.SphereTest do
  use ExUnit.Case, async: true

  alias Raytracer.Point3
  alias Raytracer.Ray3
  alias Raytracer.Shape
  alias Raytracer.Shape.Sphere
  alias Raytracer.Vector3

  describe "Raytracer.Shape.compute_intersection/2" do
    test "returns nil when no intersection exists" do
      r = %Ray3{
        origin: %Point3{x: 0.0, y: 0.0, z: 0.0},
        direction: %Vector3{dx: 0.0, dy: 1.0, dz: 0.0},
      }
      s = %Sphere{center: %Point3{x: 10.0, y: 0.0, z: 0.0}, radius: 1.0}

      assert Shape.compute_intersection(s, r) == nil
    end

    test "computes the intersection distance of a sphere and a ray" do
      r = %Ray3{
        origin: %Point3{x: 0.0, y: 0.0, z: 0.0},
        direction: %Vector3{dx: 1.0, dy: 0.0, dz: 0.0},
      }
      s = %Sphere{center: %Point3{x: 2.0, y: 0.0, z: 0.0}, radius: 1.0}

      assert Shape.compute_intersection(s, r) == 1.0
    end
  end

  describe "Raytracer.Shape.compute_outward_normal/2" do
    test "computes the outward pointing normal at a point on a sphere" do
      s = %Sphere{center: %Point3{x: 0.0, y: 0.0, z: 0.0}, radius: 1.0}
      p = %Point3{x: 1.0, y: 0.0, z: 0.0}

      assert Shape.compute_outward_normal(s, p) == %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}
    end
  end

  describe "Raytracer.Shape.compute_inward_normal/2" do
    test "computes the inward pointing normal at a point on a sphere" do
      s = %Sphere{center: %Point3{x: 0.0, y: 0.0, z: 0.0}, radius: 1.0}
      p = %Point3{x: 1.0, y: 0.0, z: 0.0}

      assert Shape.compute_inward_normal(s, p) == %Vector3{dx: -1.0, dy: 0.0, dz: 0.0}
    end
  end
end
