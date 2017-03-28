defmodule Raytracer.Shape.SphereTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.Ray
  alias Raytracer.Shape
  alias Raytracer.Shape.Sphere


  describe "Raytracer.Shape.compute_intersection/2" do
    test "returns nil when no intersection exists" do
      r = %Ray{origin: {0.0, 0.0, 0.0}, direction: {0.0, 1.0, 0.0}}
      s = %Sphere{center: {10.0, 0.0, 0.0}, radius: 1.0}

      assert Shape.compute_intersection(s, r) == nil
    end

    test "computes the intersection distance of a sphere and a ray" do
      r = %Ray{origin: {0.0, 0.0, 0.0}, direction: {1.0, 0.0, 0.0}}
      s = %Sphere{center: {2.0, 0.0, 0.0}, radius: 1.0}

      assert Shape.compute_intersection(s, r) == 1.0
    end
  end


  describe "Raytracer.Shape.compute_outward_normal/2" do
    test "computes the outward pointing normal at a point on a sphere" do
      s = %Sphere{center: {0.0, 0.0, 0.0}, radius: 1.0}
      p = {1.0, 0.0, 0.0}

      assert Shape.compute_outward_normal(s, p) == {1.0, 0.0, 0.0}
    end
  end


  describe "Raytracer.Shape.compute_inward_normal/2" do
    test "computes the inward pointing normal at a point on a sphere" do
      s = %Sphere{center: {0.0, 0.0, 0.0}, radius: 1.0}
      p = {1.0, 0.0, 0.0}

      assert Shape.compute_inward_normal(s, p) == {-1.0, 0.0, 0.0}
    end
  end
end
