defmodule Raytracer.Geometry.Bounds2Test do
  use ExUnit.Case, async: true
  use PropCheck
  import Raytracer.{Generators, GeometryTestHelpers}
  alias Raytracer.Geometry.{Bounds2, Point2, Vector2}

  @delta 1.0e-7

  doctest Bounds2

  describe "Raytracer.Geometry.Bounds2.corner/2" do
    property "returns the coordinates of the given corner index" do
      forall b <- bounds2() do
        assert Bounds2.corner(b, 0).x == b.min.x
        assert Bounds2.corner(b, 0).y == b.min.y

        assert Bounds2.corner(b, 1).x == b.max.x
        assert Bounds2.corner(b, 1).y == b.min.y

        assert Bounds2.corner(b, 2).x == b.min.x
        assert Bounds2.corner(b, 2).y == b.max.y

        assert Bounds2.corner(b, 3).x == b.max.x
        assert Bounds2.corner(b, 3).y == b.max.y
      end
    end
  end

  describe "Raytracer.Geometry.Bounds2.diagonal/1" do
    property "adding the min point and the diagonal vector returns the max point" do
      forall b <- bounds2() do
        diagonal = Bounds2.diagonal(b)
        assert_equal_within_delta Point2.add(b.min, diagonal), b.max, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Bounds2.expand/2" do
    test "expands a bounding box by the given delta value" do
      delta = 2.0
      bounds = %Bounds2{min: %Point2{x: -1.0, y: -1.0}, max: %Point2{x: 1.0, y: 1.0}}
      expected = %Bounds2{min: %Point2{x: -3.0, y: -3.0}, max: %Point2{x: 3.0, y: 3.0}}

      assert Bounds2.expand(bounds, delta) == expected
    end
  end

  describe "Raytracer.Geometry.Bounds2.inside?/2" do
    test "returns true if the point is inside the bounding box" do
      bounds = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 1.0, y: 1.0}}
      point = %Point2{x: 0.5, y: 0.5}

      assert Bounds2.inside?(bounds, point)
    end

    test "returns false if the point is outside the bounding box" do
      bounds = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 1.0, y: 1.0}}
      point = %Point2{x: 2.0, y: 2.0}

      refute Bounds2.inside?(bounds, point)
    end
  end

  describe "Raytracer.Geometry.Bounds2.inside_exclusive?/2" do
    test "returns true if the point is inside the bounding box" do
      bounds = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 1.0, y: 1.0}}
      point = %Point2{x: 0.5, y: 0.5}

      assert Bounds2.inside_exclusive?(bounds, point)
    end

    test "returns false if the point is outside the bounding box" do
      bounds = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 1.0, y: 1.0}}
      point = %Point2{x: 2.0, y: 2.0}

      refute Bounds2.inside_exclusive?(bounds, point)
    end

    test "returns false if the point is on the upper boundary of the bounding box" do
      bounds = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 1.0, y: 1.0}}
      point = %Point2{x: 1.0, y: 1.0}

      refute Bounds2.inside_exclusive?(bounds, point)
    end
  end

  describe "Raytracer.Geometry.Bounds2.intersect/2" do
    test "create a new bounding box that is the intersection of the given bounding boxes" do
      bounds1 = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 2.0, y: 2.0}}
      bounds2 = %Bounds2{min: %Point2{x: -2.0, y: -2.0}, max: %Point2{x: 1.0, y: 1.0}}
      expected = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 1.0, y: 1.0}}

      assert Bounds2.intersect(bounds1, bounds2) == expected
    end
  end

  describe "Raytracer.Geometry.Bounds2.lerp/2" do
    test "linearly interpolates between the corners of the box by the given amount in each direction" do
      bounds = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 2.0, y: 2.0}}

      assert Bounds2.lerp(bounds, 0.5, 0.25) == %Point2{x: 1.0, y: 0.5}
    end
  end

  describe "Raytracer.Geometry.Bounds2.maximum_extent/1" do
    test "returns an atom representing the axis with the largest value" do
      bounds1 = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 2.0, y: 1.0}}
      bounds2 = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 1.0, y: 2.0}}

      assert Bounds2.maximum_extent(bounds1) == :x
      assert Bounds2.maximum_extent(bounds2) == :y
    end
  end

  describe "Raytracer.Geometry.Bounds2.offset/2" do
    test "returns the continuous position of a point relative to the corners of the bounding box" do
      bounds = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 2.0, y: 2.0}}
      point = %Point2{x: 1.0, y: 0.5}

      assert Bounds2.offset(bounds, point) == {0.5, 0.25}
    end

    test "when min point is greater than max point" do
      bounds = %Bounds2{min: %Point2{x: 2.0, y: 2.0}, max: %Point2{x: 0.0, y: 0.0}}
      point = %Point2{x: 1.0, y: 0.5}

      assert Bounds2.offset(bounds, point) == {-1.0, -1.5}
    end
  end

  describe "Raytracer.Geometry.Bounds2.overlap?/2" do
    test "returns true if the two bounding boxes overlap" do
      bounds1 = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 2.0, y: 2.0}}
      bounds2 = %Bounds2{min: %Point2{x: -2.0, y: -2.0}, max: %Point2{x: 1.0, y: 1.0}}

      assert Bounds2.overlap?(bounds1, bounds2)
    end

    test "returns false if the two bounding boxes do not overlap" do
      bounds1 = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 2.0, y: 2.0}}
      bounds2 = %Bounds2{min: %Point2{x: -2.0, y: -2.0}, max: %Point2{x: -1.0, y: -1.0}}

      refute Bounds2.overlap?(bounds1, bounds2)
    end
  end

  describe "Raytracer.Geometry.Bounds2.union/2" do
    test "creates a new bounding box that encompasses the given bounding boxes" do
      bounds1 = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 1.0, y: 1.0}}
      bounds2 = %Bounds2{min: %Point2{x: -1.0, y: -1.0}, max: %Point2{x: 0.0, y: 0.0}}
      expected = %Bounds2{min: %Point2{x: -1.0, y: -1.0}, max: %Point2{x: 1.0, y: 1.0}}

      assert Bounds2.union(bounds1, bounds2) == expected
    end

    test "creates a new bounding box that encompasses the given bounding box and point" do
      bounds = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 1.0, y: 1.0}}
      point = %Point2{x: 2.0, y: 2.0}
      expected = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 2.0, y: 2.0}}

      assert Bounds2.union(bounds, point) == expected
    end
  end
end
