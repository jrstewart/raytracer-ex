defmodule Raytracer.Geometry.BoundsTest do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.Bounds


  describe "Raytracer.Geometry.Bounds.corner/2" do
    test "returns the coordinates of the given corner index" do
      b = %Bounds{min_point: {0.0, 0.0}, max_point: {1.0, 1.0}}

      assert Bounds.corner(b, 0) == {0.0, 0.0}
      assert Bounds.corner(b, 1) == {1.0, 0.0}
      assert Bounds.corner(b, 2) == {0.0, 1.0}
      assert Bounds.corner(b, 3) == {1.0, 1.0}

      b = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {1.0, 1.0, 1.0}}

      assert Bounds.corner(b, 0) == {0.0, 0.0, 0.0}
      assert Bounds.corner(b, 1) == {1.0, 0.0, 0.0}
      assert Bounds.corner(b, 2) == {0.0, 1.0, 0.0}
      assert Bounds.corner(b, 3) == {1.0, 1.0, 0.0}
      assert Bounds.corner(b, 4) == {0.0, 0.0, 1.0}
      assert Bounds.corner(b, 5) == {1.0, 0.0, 1.0}
      assert Bounds.corner(b, 6) == {0.0, 1.0, 1.0}
      assert Bounds.corner(b, 7) == {1.0, 1.0, 1.0}
    end
  end


  describe "Raytracer.Geometry.Bounds.diagonal/1" do
    test "returns a vector pointing from the min point to the max point" do
      b = %Bounds{min_point: {-1.0, -1.0}, max_point: {1.0, 1.0}}

      assert Bounds.diagonal(b) == {2.0, 2.0}

      b = %Bounds{min_point: {-1.0, -1.0, -1.0}, max_point: {1.0, 1.0, 1.0}}

      assert Bounds.diagonal(b) == {2.0, 2.0, 2.0}
    end
  end


  describe "Raytracer.Geometry.Bounds.expand/2" do
    test "expands a bounding box by the given delta value" do
      delta = 2.0

      b = %Bounds{min_point: {-1.0, -1.0}, max_point: {1.0, 1.0}}
      expected = %Bounds{min_point: {-3.0, -3.0}, max_point: {3.0, 3.0}}

      assert Bounds.expand(b, delta) == expected

      b = %Bounds{min_point: {-1.0, -1.0, -1.0}, max_point: {1.0, 1.0, 1.0}}
      expected = %Bounds{min_point: {-3.0, -3.0, -3.0}, max_point: {3.0, 3.0, 3.0}}

      assert Bounds.expand(b, delta) == expected
    end
  end


  describe "Raytracer.Geometry.Bounds.inside?/2" do
    test "returns true if the point is inside the bounding box" do
      b = %Bounds{min_point: {0.0, 0.0}, max_point: {1.0, 1.0}}
      p = {0.5, 0.5}

      assert Bounds.inside?(b, p)

      b = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {1.0, 1.0, 1.0}}
      p = {0.5, 0.5, 0.5}

      assert Bounds.inside?(b, p)
    end

    test "returns false if the point is outside the bounding box" do
      b = %Bounds{min_point: {0.0, 0.0}, max_point: {1.0, 1.0}}
      p = {2.0, 2.0}

      refute Bounds.inside?(b, p)

      b = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {1.0, 1.0, 1.0}}
      p = {2.0, 2.0, 2.0}

      refute Bounds.inside?(b, p)
    end
  end


  describe "Raytracer.Geometry.Bounds.inside_exclusive?/2" do
    test "returns true if the point is inside the bounding box" do
      b = %Bounds{min_point: {0.0, 0.0}, max_point: {1.0, 1.0}}
      p = {0.5, 0.5}

      assert Bounds.inside_exclusive?(b, p)

      b = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {1.0, 1.0, 1.0}}
      p = {0.5, 0.5, 0.5}

      assert Bounds.inside_exclusive?(b, p)
    end

    test "returns false if the point is outside the bounding box" do
      b = %Bounds{min_point: {0.0, 0.0}, max_point: {1.0, 1.0}}
      p = {2.0, 2.0}

      refute Bounds.inside_exclusive?(b, p)

      b = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {1.0, 1.0, 1.0}}
      p = {2.0, 2.0, 2.0}

      refute Bounds.inside_exclusive?(b, p)
    end

    test "returns false if the point is on the upper boundary of the bounding box" do
      b = %Bounds{min_point: {0.0, 0.0}, max_point: {1.0, 1.0}}
      p = {1.0, 1.0}

      refute Bounds.inside_exclusive?(b, p)

      b = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {1.0, 1.0, 1.0}}
      p = {1.0, 1.0, 1.0}

      refute Bounds.inside_exclusive?(b, p)
    end
  end


  describe "Raytracer.Geometry.Bounds.intersect/2" do
    test "create a new bounding box that is the intersection of the given bounding boxes" do
      b1 = %Bounds{min_point: {0.0, 0.0}, max_point: {2.0, 2.0}}
      b2 = %Bounds{min_point: {-2.0, -2.0}, max_point: {1.0, 1.0}}
      expected = %Bounds{min_point: {0.0, 0.0}, max_point: {1.0, 1.0}}

      assert Bounds.intersect(b1, b2) == expected

      b1 = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {2.0, 2.0, 2.0}}
      b2 = %Bounds{min_point: {-2.0, -2.0, -2.0}, max_point: {1.0, 1.0, 1.0}}
      expected = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {1.0, 1.0, 1.0}}

      assert Bounds.intersect(b1, b2) == expected
    end
  end


  describe "Raytracer.Geometry.Bounds.lerp/2" do
    test "linearly interpolates between the corners of the box by the given amount in each direction" do
      b = %Bounds{min_point: {0.0, 0.0}, max_point: {2.0, 2.0}}

      assert Bounds.lerp(b, %{tx: 0.5, ty: 0.25}) == {1.0, 0.5}

      b = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {2.0, 2.0, 2.0}}

      assert Bounds.lerp(b, %{tx: 0.5, ty: 0.25, tz: 0.75}) == {1.0, 0.5, 1.5}
    end
  end


  describe "Raytracer.Geometry.Bounds.maximum_extent/1" do
    test "returns an atom representing the axis with the largest value" do
      b1 = %Bounds{min_point: {0.0, 0.0}, max_point: {2.0, 1.0}}
      b2 = %Bounds{min_point: {0.0, 0.0}, max_point: {1.0, 2.0}}

      assert Bounds.maximum_extent(b1) == :x
      assert Bounds.maximum_extent(b2) == :y

      b1 = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {2.0, 1.0, 0.5}}
      b2 = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {1.0, 2.0, 0.5}}
      b3 = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {1.0, 1.0, 2.0}}

      assert Bounds.maximum_extent(b1) == :x
      assert Bounds.maximum_extent(b2) == :y
      assert Bounds.maximum_extent(b3) == :z
    end
  end


  describe "Raytracer.Geometry.Bounds.offset/2" do
    test "returns the continuous position of a point relative to the corners of the bounding box" do
      b = %Bounds{min_point: {0.0, 0.0}, max_point: {2.0, 2.0}}
      p = {1.0, 0.5}

      assert Bounds.offset(b, p) == {0.5, 0.25}

      b = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {2.0, 2.0, 2.0}}
      p = {1.0, 0.5, 2.0}

      assert Bounds.offset(b, p) == {0.5, 0.25, 1.0}
    end

    test "when min point is greater than max point" do
      b = %Bounds{min_point: {2.0, 2.0}, max_point: {0.0, 0.0}}
      p = {1.0, 0.5}

      assert Bounds.offset(b, p) == {-1.0, -1.5}

      b = %Bounds{min_point: {2.0, 2.0, 2.0}, max_point: {0.0, 0.0, 0.0}}
      p = {1.0, 0.5, 0.0}

      assert Bounds.offset(b, p) == {-1.0, -1.5, -2.0}
    end
  end


  describe "Raytracer.Geometry.Bounds.overlap?/2" do
    test "returns true if the two bounding boxes overlap" do
      b1 = %Bounds{min_point: {0.0, 0.0}, max_point: {2.0, 2.0}}
      b2 = %Bounds{min_point: {-2.0, -2.0}, max_point: {1.0, 1.0}}

      assert Bounds.overlap?(b1, b2)

      b1 = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {2.0, 2.0, 2.0}}
      b2 = %Bounds{min_point: {-2.0, -2.0, -2.0}, max_point: {1.0, 1.0, 1.0}}

      assert Bounds.overlap?(b1, b2)
    end

    test "returns false if the two bounding boxes do not overlap" do
      b1 = %Bounds{min_point: {0.0, 0.0}, max_point: {2.0, 2.0}}
      b2 = %Bounds{min_point: {-2.0, -2.0}, max_point: {-1.0, -1.0}}

      refute Bounds.overlap?(b1, b2)

      b1 = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {2.0, 2.0, 2.0}}
      b2 = %Bounds{min_point: {-2.0, -2.0, -2.0}, max_point: {-1.0, -1.0, -1.0}}

      refute Bounds.overlap?(b1, b2)
    end
  end


  describe "Raytracer.Geometry.Bounds.union/2" do
    test "creates a new bounding box that encompasses the given bounding box and point" do
      b = %Bounds{min_point: {0.0, 0.0}, max_point: {1.0, 1.0}}
      p = {2.0, 2.0}
      expected = %Bounds{min_point: {0.0, 0.0}, max_point: {2.0, 2.0}}

      assert Bounds.union(b, p) == expected

      b = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {1.0, 1.0, 1.0}}
      p = {2.0, 2.0, 2.0}
      expected = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {2.0, 2.0, 2.0}}

      assert Bounds.union(b, p) == expected
    end

    test "creates a new bounding box that encompasses the given bounding boxes" do
      b1 = %Bounds{min_point: {0.0, 0.0}, max_point: {1.0, 1.0}}
      b2 = %Bounds{min_point: {-1.0, -1.0}, max_point: {0.0, 0.0}}
      expected = %Bounds{min_point: {-1.0, -1.0}, max_point: {1.0, 1.0}}

      assert Bounds.union(b1, b2) == expected

      b1 = %Bounds{min_point: {0.0, 0.0, 0.0}, max_point: {1.0, 1.0, 1.0}}
      b2 = %Bounds{min_point: {-1.0, -1.0, -1.0}, max_point: {0.0, 0.0, 0.0}}
      expected = %Bounds{min_point: {-1.0, -1.0, -1.0}, max_point: {1.0, 1.0, 1.0}}

      assert Bounds.union(b1, b2) == expected
    end
  end
end
