defmodule Raytracer.Geometry.Bounds2Test do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.{Bounds2, Point2, Vector2}

  describe "Raytracer.Geometry.Bounds2.corner/2" do
    test "returns the coordinates of the given corner index" do
      b = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }

      assert Bounds2.corner(b, 0) == %Point2{x: 0.0, y: 0.0}
      assert Bounds2.corner(b, 1) == %Point2{x: 1.0, y: 0.0}
      assert Bounds2.corner(b, 2) == %Point2{x: 0.0, y: 1.0}
      assert Bounds2.corner(b, 3) == %Point2{x: 1.0, y: 1.0}
    end
  end

  describe "Raytracer.Geometry.Bounds2.diagonal/1" do
    test "returns the vector pointing from the min point to the max point" do
      b = %Bounds2{
        min_point: %Point2{x: -1.0, y: -1.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }

      assert Bounds2.diagonal(b) == %Vector2{dx: 2.0, dy: 2.0}
    end
  end

  describe "Raytracer.Geometry.Bounds2.expand/2" do
    test "expands a bounding box by the given delta value" do
      b = %Bounds2{
        min_point: %Point2{x: -1.0, y: -1.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }
      delta = 2.0
      expected = %Bounds2{
        min_point: %Point2{x: -3.0, y: -3.0},
        max_point: %Point2{x: 3.0, y: 3.0},
      }

      assert Bounds2.expand(b, delta) == expected
    end
  end

  describe "Raytracer.Geometry.Bounds2.inside?/2" do
    test "returns true if the point is inside the bounding box" do
      b = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }
      p = %Point2{x: 0.5, y: 0.5}

      assert Bounds2.inside?(b, p)
    end

    test "returns false if the point is not inside the bounding box" do
      b = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }
      p = %Point2{x: 2.0, y: 2.0}

      refute Bounds2.inside?(b, p)
    end
  end

  describe "Raytracer.Geometry.Bounds2.inside_exclusive?/2" do
    test "returns true if the point is inside the bounding box" do
      b = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }
      p = %Point2{x: 0.5, y: 0.5}

      assert Bounds2.inside_exclusive?(b, p)
    end

    test "returns false if the point is not inside the bounding box" do
      b = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }
      p = %Point2{x: 2.0, y: 2.0}

      refute Bounds2.inside_exclusive?(b, p)
    end

    test "returns false if the point is on the upper boundary of the bounding box" do
      b = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }
      p = %Point2{x: 1.0, y: 1.0}

      refute Bounds2.inside_exclusive?(b, p)
    end
  end

  describe "Raytracer.Geometry.Bounds2.intersect/2" do
    test "create a new bounding box that is the intersection of the given bounding boxes" do
      b1 = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 2.0, y: 2.0},
      }
      b2 = %Bounds2{
        min_point: %Point2{x: -2.0, y: -2.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }
      expected = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }

      assert Bounds2.intersect(b1, b2) == expected
    end
  end

  describe "Raytracer.Geometry.Bounds2.lerp/2" do
    test "linearly interpolates between the corners of the box by the given amount in each direction" do
      b = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 2.0, y: 2.0},
      }

      assert Bounds2.lerp(b, %{tx: 0.5, ty: 0.25}) == %Point2{x: 1.0, y: 0.5}
    end
  end

  describe "Raytracer.Geometry.Bounds2.maximum_extent/1" do
    test "returns an atom representing the axis with the largest value" do
      b1 = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 2.0, y: 1.0},
      }
      b2 = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 1.0, y: 2.0},
      }

      assert Bounds2.maximum_extent(b1) == :x
      assert Bounds2.maximum_extent(b2) == :y
    end
  end

  describe "Raytracer.Geometry.Bounds2.offset/2" do
    test "returns the continuous position of a point relative to the corners of the bounding box" do
      b = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 2.0, y: 2.0},
      }
      p = %Point2{x: 1.0, y: 0.5}

      assert Bounds2.offset(b, p) == %{x: 0.5, y: 0.25}
    end

    test "when min point is greater than max point" do
      b = %Bounds2{
        min_point: %Point2{x: 2.0, y: 2.0},
        max_point: %Point2{x: 0.0, y: 0.0},
      }
      p = %Point2{x: 1.0, y: 0.5}

      assert Bounds2.offset(b, p) == %{x: -1.0, y: -1.5}
    end
  end

  describe "Raytracer.Geometry.Bounds2.overlap?/2" do
    test "returns true if the two bounding boxes overlap" do
      b1 = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 2.0, y: 2.0},
      }
      b2 = %Bounds2{
        min_point: %Point2{x: -2.0, y: -2.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }

      assert Bounds2.overlap?(b1, b2)
    end

    test "returns false if the two bounding boxes do not overlap" do
      b1 = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 2.0, y: 2.0},
      }
      b2 = %Bounds2{
        min_point: %Point2{x: -2.0, y: -2.0},
        max_point: %Point2{x: -1.0, y: -1.0},
      }

      refute Bounds2.overlap?(b1, b2)
    end
  end

  describe "Raytracer.Geometry.Bounds2.union/2" do
    test "creates a new bounding box that encompasses the given bounding box and point" do
      b = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }
      expected = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 2.0, y: 2.0},
      }
      p = %Point2{x: 2.0, y: 2.0}

      assert Bounds2.union(b, p) == expected
    end

    test "creates a new bounding box that encompasses the given bounding boxes" do
      b1 = %Bounds2{
        min_point: %Point2{x: 0.0, y: 0.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }
      b2 = %Bounds2{
        min_point: %Point2{x: -1.0, y: -1.0},
        max_point: %Point2{x: 0.0, y: 0.0},
      }
      expected = %Bounds2{
        min_point: %Point2{x: -1.0, y: -1.0},
        max_point: %Point2{x: 1.0, y: 1.0},
      }

      assert Bounds2.union(b1, b2) == expected
    end
  end
end
