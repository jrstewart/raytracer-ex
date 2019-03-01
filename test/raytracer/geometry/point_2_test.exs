defmodule Raytracer.Geometry.Point2Test do
  use ExUnit.Case, async: true
  use PropCheck
  import Raytracer.{Generators, GeometryTestHelpers}
  alias Raytracer.Geometry.{Point2, Vector2}

  @delta 1.0e-7

  doctest Point2

  describe "Raytracer.Geometry.Point2.abs/1" do
    property "computes the absolute value of the point coordinates" do
      forall p <- point2() do
        result = Point2.abs(p)
        assert result.x == if(p.x >= 0.0, do: p.x, else: -p.x)
        assert result.y == if(p.y >= 0.0, do: p.y, else: -p.y)
      end
    end
  end

  describe "Raytracer.Geometry.Point2.add/2" do
    property "subtracting one of the points from the resulting point returns the other point" do
      forall {p1, p2} <- {point2(), point2()} do
        result = Point2.add(p1, p2)
        assert_in_delta result.x - p2.x, p1.x, @delta
        assert_in_delta result.y - p2.y, p1.y, @delta
      end
    end

    property "subtracting the vector from the resulting point returns the original point" do
      forall {p, v} <- {point2(), vector2()} do
        result = Point2.add(p, v)
        assert_in_delta result.x - v.dx, p.x, @delta
        assert_in_delta result.y - v.dy, p.y, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Point2.distance_between/2" do
    property "the distance between two points is non-negative" do
      forall {p1, p2} <- {point2(), point2()} do
        assert Point2.distance_between(p1, p2) >= 0.0
      end
    end

    property "the distance between a point and itself is 0" do
      forall p <- point2() do
        assert_in_delta Point2.distance_between(p, p), 0.0, @delta
      end
    end

    property "the distance is the square root of the squared distance between two points" do
      forall {p1, p2} <- {point2(), point2()} do
        assert_in_delta Point2.distance_between(p1, p2),
                        Point2.distance_between_squared(p1, p2) |> :math.sqrt(),
                        @delta
      end
    end
  end

  describe "Raytracer.Geometry.Point2.distance_between_squared/2" do
    property "the squared distance between two points is non-negative" do
      forall {p1, p2} <- {point2(), point2()} do
        assert Point2.distance_between_squared(p1, p2) >= 0.0
      end
    end

    property "the squared distance between a point and itself is 0" do
      forall p <- point2() do
        assert_in_delta Point2.distance_between_squared(p, p), 0.0, @delta
      end
    end

    property "the squared distance is the distance between two points squared" do
      forall {p1, p2} <- {point2(), point2()} do
        assert_in_delta Point2.distance_between_squared(p1, p2),
                        Point2.distance_between(p1, p2) |> :math.pow(2),
                        @delta
      end
    end
  end

  describe "Raytracer.Geometry.Point2.divide/2" do
    property "multiplying the resulting point by the scalar returns the original point" do
      forall {p, scalar} <- {point2(), non_zero_float()} do
        result = Point2.divide(p, scalar)
        assert_in_delta result.x * scalar, p.x, @delta
        assert_in_delta result.y * scalar, p.y, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Point2.lerp/3" do
    property "computes the point between two points at position t" do
      forall {p1, p2, t} <- {point2(), point2(), float(0.0, 1.0)} do
        assert_equal_within_delta Point2.lerp(p1, p2, t),
                                  Point2.add(p1, Vector2.multiply(Point2.subtract(p2, p1), t))
      end
    end

    property "when t = 0 the first point is returned" do
      forall {p1, p2} <- {point2(), point2()} do
        result = Point2.lerp(p1, p2, 0.0)
        assert result == p1
      end
    end

    property "when t = 1 the second point is returned" do
      forall {p1, p2} <- {point2(), point2()} do
        result = Point2.lerp(p1, p2, 1.0)
        assert result == p2
      end
    end
  end

  describe "Raytracer.Geometry.Point2.multiply/2" do
    property "dividing the resulting point by the scalar returns the original point" do
      forall {p, scalar} <- {point2(), non_zero_float()} do
        result = Point2.multiply(p, scalar)
        assert_in_delta result.x / scalar, p.x, @delta
        assert_in_delta result.y / scalar, p.y, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Point2.subtract/2" do
    property "adding the second point to the resulting vector returns the first point" do
      forall {p1, p2} <- {point2(), point2()} do
        result = Point2.subtract(p1, p2)
        assert_in_delta result.dx + p2.x, p1.x, @delta
        assert_in_delta result.dy + p2.y, p1.y, @delta
      end
    end

    property "subtracting the resulting point from the point returns the vector" do
      forall {p, v} <- {point2(), vector2()} do
        result = Point2.subtract(p, v)
        assert_in_delta p.x - result.x, v.dx, @delta
        assert_in_delta p.y - result.y, v.dy, @delta
      end
    end
  end
end
