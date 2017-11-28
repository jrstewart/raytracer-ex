defmodule Raytracer.Geometry.Bounds3Test do
  use ExUnit.Case, async: true

  import Raytracer.GeometryTestHelpers

  alias Raytracer.{Transform, Transformable}
  alias Raytracer.Geometry.{Bounds3, Point3, Vector3}

  describe "Raytracer.Geometry.Bounds3.corner/2" do
    test "returns the coordinates of the given corner index" do
      bounds = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      assert Bounds3.corner(bounds, 0) == %Point3{x: 0.0, y: 0.0, z: 0.0}
      assert Bounds3.corner(bounds, 1) == %Point3{x: 1.0, y: 0.0, z: 0.0}
      assert Bounds3.corner(bounds, 2) == %Point3{x: 0.0, y: 1.0, z: 0.0}
      assert Bounds3.corner(bounds, 3) == %Point3{x: 1.0, y: 1.0, z: 0.0}
      assert Bounds3.corner(bounds, 4) == %Point3{x: 0.0, y: 0.0, z: 1.0}
      assert Bounds3.corner(bounds, 5) == %Point3{x: 1.0, y: 0.0, z: 1.0}
      assert Bounds3.corner(bounds, 6) == %Point3{x: 0.0, y: 1.0, z: 1.0}
      assert Bounds3.corner(bounds, 7) == %Point3{x: 1.0, y: 1.0, z: 1.0}
    end
  end

  describe "Raytracer.Geometry.Bounds3.diagonal/1" do
    test "returns a vector pointing from the min point to the max point" do
      bounds = %Bounds3{
        min: %Point3{x: -1.0, y: -1.0, z: -1.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      assert Bounds3.diagonal(bounds) == %Vector3{dx: 2.0, dy: 2.0, dz: 2.0}
    end
  end

  describe "Raytracer.Geometry.Bounds3.expand/2" do
    test "expands a bounding box by the given delta value" do
      bounds = %Bounds3{
        min: %Point3{x: -1.0, y: -1.0, z: -1.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      expected = %Bounds3{
        min: %Point3{x: -3.0, y: -3.0, z: -3.0},
        max: %Point3{x: 3.0, y: 3.0, z: 3.0}
      }

      assert Bounds3.expand(bounds, 2.0) == expected
    end
  end

  describe "Raytracer.Geometry.Bounds3.inside?/2" do
    test "returns true if the point is inside the bounding box" do
      bounds = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      point = %Point3{x: 0.5, y: 0.5, z: 0.5}

      assert Bounds3.inside?(bounds, point)
    end

    test "returns false if the point is outside the bounding box" do
      bounds = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      point = %Point3{x: 2.0, y: 2.0, z: 2.0}

      refute Bounds3.inside?(bounds, point)
    end
  end

  describe "Raytracer.Geometry.Bounds3.inside_exclusive?/2" do
    test "returns true if the point is inside the bounding box" do
      bounds = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      point = %Point3{x: 0.5, y: 0.5, z: 0.5}

      assert Bounds3.inside_exclusive?(bounds, point)
    end

    test "returns false if the point is outside the bounding box" do
      bounds = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      point = %Point3{x: 2.0, y: 2.0, z: 2.0}

      refute Bounds3.inside_exclusive?(bounds, point)
    end

    test "returns false if the point is on the upper boundary of the bounding box" do
      bounds = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      point = %Point3{x: 1.0, y: 1.0, z: 1.0}

      refute Bounds3.inside_exclusive?(bounds, point)
    end
  end

  describe "Raytracer.Geometry.Bounds3.intersect/2" do
    test "create a new bounding box that is the intersection of the given bounding boxes" do
      bounds1 = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 2.0, y: 2.0, z: 2.0}
      }

      bounds2 = %Bounds3{
        min: %Point3{x: -2.0, y: -2.0, z: -2.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      expected = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      assert Bounds3.intersect(bounds1, bounds2) == expected
    end
  end

  describe "Raytracer.Geometry.Bounds3.lerp/2" do
    test "linearly interpolates between the corners of the box by the given amount in each direction" do
      bounds = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 2.0, y: 2.0, z: 2.0}
      }

      assert Bounds3.lerp(bounds, 0.5, 0.25, 0.75) == %Point3{x: 1.0, y: 0.5, z: 1.5}
    end
  end

  describe "Raytracer.Geometry.Bounds3.maximum_extent/1" do
    test "returns an atom representing the axis with the largest value" do
      bounds1 = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 2.0, y: 1.0, z: 0.5}
      }

      bounds2 = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 1.0, y: 2.0, z: 0.5}
      }

      bounds3 = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 1.0, y: 1.0, z: 2.5}
      }

      assert Bounds3.maximum_extent(bounds1) == :x
      assert Bounds3.maximum_extent(bounds2) == :y
      assert Bounds3.maximum_extent(bounds3) == :z
    end
  end

  describe "Raytracer.Geometry.Bounds3.offset/2" do
    test "returns the continuous position of a point relative to the corners of the bounding box" do
      bounds = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 2.0, y: 2.0, z: 2.0}
      }

      point = %Point3{x: 1.0, y: 0.5, z: 2.0}

      assert Bounds3.offset(bounds, point) == {0.5, 0.25, 1.0}
    end

    test "when min point is greater than max point" do
      bounds = %Bounds3{
        min: %Point3{x: 2.0, y: 2.0, z: 2.0},
        max: %Point3{x: 0.0, y: 0.0, z: 0.0}
      }

      point = %Point3{x: 1.0, y: 0.5, z: 0.0}

      assert Bounds3.offset(bounds, point) == {-1.0, -1.5, -2.0}
    end
  end

  describe "Raytracer.Geometry.Bounds3.overlap?/2" do
    test "returns true if the two bounding boxes overlap" do
      bounds1 = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 2.0, y: 2.0, z: 2.0}
      }

      bounds2 = %Bounds3{
        min: %Point3{x: -2.0, y: -2.0, z: -2.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      assert Bounds3.overlap?(bounds1, bounds2)
    end

    test "returns false if the two bounding boxes do not overlap" do
      bounds1 = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 2.0, y: 2.0, z: 2.0}
      }

      bounds2 = %Bounds3{
        min: %Point3{x: -2.0, y: -2.0, z: -2.0},
        max: %Point3{x: -1.0, y: -1.0, z: -1.0}
      }

      refute Bounds3.overlap?(bounds1, bounds2)
    end
  end

  describe "Raytracer.Geometry.Bounds3.union/2" do
    test "creates a new bounding box that encompasses the given bounding boxes" do
      bounds1 = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      bounds2 = %Bounds3{
        min: %Point3{x: -1.0, y: -1.0, z: -1.0},
        max: %Point3{x: 0.0, y: 0.0, z: 0.0}
      }

      expected = %Bounds3{
        min: %Point3{x: -1.0, y: -1.0, z: -1.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      assert Bounds3.union(bounds1, bounds2) == expected
    end

    test "creates a new bounding box that encompasses the given bounding box and point" do
      bounds = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 1.0, y: 1.0, z: 1.0}
      }

      point = %Point3{x: 2.0, y: 2.0, z: 2.0}

      expected = %Bounds3{
        min: %Point3{x: 0.0, y: 0.0, z: 0.0},
        max: %Point3{x: 2.0, y: 2.0, z: 2.0}
      }

      assert Bounds3.union(bounds, point) == expected
    end
  end

  describe "Raytracer.Transformable.apply_transform/2" do
    test "transforms a bounding box and returns the result" do
      bounds = %Bounds3{
        min: %Point3{x: -1.0, y: -2.0, z: -3.0},
        max: %Point3{x: 1.0, y: 2.0, z: 3.0}
      }

      #
      # Test scale transform
      #

      transform = Transform.scale(2.0, 3.0, 4.0)

      expected = %Bounds3{
        min: %Point3{x: -2.0, y: -6.0, z: -12.0},
        max: %Point3{x: 2.0, y: 6.0, z: 12.0}
      }

      result = Transformable.apply_transform(bounds, transform)

      assert_equal_within_delta(result.min, expected.min)
      assert_equal_within_delta(result.max, expected.max)

      #
      # Test rotation transform
      #

      transform = Transform.rotate(180.0, %Vector3{dx: 1.0, dy: 0.0, dz: 0.0})

      result = Transformable.apply_transform(bounds, transform)

      assert_equal_within_delta(result.min, bounds.min)
      assert_equal_within_delta(result.max, bounds.max)
    end
  end
end
