defmodule Raytracer.Geometry.Point3Test do
  use ExUnit.Case, async: true
  use PropCheck
  import Raytracer.{GeometryTestHelpers, Generators}
  alias Raytracer.{Transform, Transformable}
  alias Raytracer.Geometry.{Point3, Vector3}

  @delta 1.0e-7

  doctest Point3

  describe "Raytracer.Geometry.Point3.abs/1" do
    property "computes the absolute value of the point coordinates" do
      forall p <- point3() do
        result = Point3.abs(p)
        assert result.x == if(p.x >= 0.0, do: p.x, else: -p.x)
        assert result.y == if(p.y >= 0.0, do: p.y, else: -p.y)
        assert result.z == if(p.z >= 0.0, do: p.z, else: -p.z)
      end
    end
  end

  describe "Raytracer.Geometry.Point3.add/2" do
    property "subtracting one of the points from the resulting point returns the other point" do
      forall {p1, p2} <- {point3(), point3()} do
        result = Point3.add(p1, p2)
        assert_in_delta result.x - p2.x, p1.x, @delta
        assert_in_delta result.y - p2.y, p1.y, @delta
        assert_in_delta result.z - p2.z, p1.z, @delta
      end
    end

    property "subtracting the vector from the resulting point returns the original point" do
      forall {p, v} <- {point3(), vector3()} do
        result = Point3.add(p, v)
        assert_in_delta result.x - v.dx, p.x, @delta
        assert_in_delta result.y - v.dy, p.y, @delta
        assert_in_delta result.z - v.dz, p.z, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Point3.distance_between/2" do
    property "the distance between two points is non-negative" do
      forall {p1, p2} <- {point3(), point3()} do
        assert Point3.distance_between(p1, p2) >= 0.0
      end
    end

    property "the distance between a point and itself is 0" do
      forall p <- point3() do
        assert_in_delta Point3.distance_between(p, p), 0.0, @delta
      end
    end

    property "the distance is the square root of the squared distance between two points" do
      forall {p1, p2} <- {point3(), point3()} do
        assert_in_delta Point3.distance_between(p1, p2),
                        Point3.distance_between_squared(p1, p2) |> :math.sqrt(),
                        @delta
      end
    end
  end

  describe "Raytracer.Geometry.Point3.distance_between_squared/2" do
    property "the squared distance between two points is non-negative" do
      forall {p1, p2} <- {point3(), point3()} do
        assert Point3.distance_between_squared(p1, p2) >= 0.0
      end
    end

    property "the squared distance between a point and itself is 0" do
      forall p <- point3() do
        assert_in_delta Point3.distance_between_squared(p, p), 0.0, @delta
      end
    end

    property "the squared distance is the distance between two points squared" do
      forall {p1, p2} <- {point3(), point3()} do
        assert_in_delta Point3.distance_between_squared(p1, p2),
                        Point3.distance_between(p1, p2) |> :math.pow(2),
                        @delta
      end
    end
  end

  describe "Raytracer.Geometry.Point3.divide/2" do
    property "multiplying the resulting point by the scalar returns the original point" do
      forall {p, scalar} <- {point3(), non_zero_float()} do
        result = Point3.divide(p, scalar)
        assert_in_delta result.x * scalar, p.x, @delta
        assert_in_delta result.y * scalar, p.y, @delta
        assert_in_delta result.z * scalar, p.z, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Point3.lerp/3" do
    property "computes the point between two points at position t" do
      forall {p1, p2, t} <- {point3(), point3(), float(0.0, 1.0)} do
        assert_equal_within_delta Point3.lerp(p1, p2, t),
                                  Point3.add(p1, Vector3.multiply(Point3.subtract(p2, p1), t))
      end
    end

    property "when t = 0 the first point is returned" do
      forall {p1, p2} <- {point3(), point3()} do
        result = Point3.lerp(p1, p2, 0.0)
        assert result == p1
      end
    end

    property "when t = 1 the second point is returned" do
      forall {p1, p2} <- {point3(), point3()} do
        result = Point3.lerp(p1, p2, 1.0)
        assert result == p2
      end
    end
  end

  describe "Raytracer.Geometry.Point3.multiply/2" do
    property "dividing the resulting point by the scalar returns the original point" do
      forall {p, scalar} <- {point3(), non_zero_float()} do
        result = Point3.multiply(p, scalar)
        assert_in_delta result.x / scalar, p.x, @delta
        assert_in_delta result.y / scalar, p.y, @delta
        assert_in_delta result.z / scalar, p.z, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Point3.subtract/2" do
    property "adding the second point to the resulting vector returns the first point" do
      forall {p1, p2} <- {point3(), point3()} do
        result = Point3.subtract(p1, p2)
        assert_in_delta result.dx + p2.x, p1.x, @delta
        assert_in_delta result.dy + p2.y, p1.y, @delta
        assert_in_delta result.dz + p2.z, p1.z, @delta
      end
    end

    property "subtracting the resulting point from the point returns the vector" do
      forall {p, v} <- {point3(), vector3()} do
        result = Point3.subtract(p, v)
        assert_in_delta p.x - result.x, v.dx, @delta
        assert_in_delta p.y - result.y, v.dy, @delta
        assert_in_delta p.z - result.z, v.dz, @delta
      end
    end
  end

  describe "Raytracer.Transformable.apply_transform/2" do
    property "applying the inverse transformation to a transformed point produces the original point" do
      forall {p, m} <- {point3(), affine_matrix4x4()} do
        t = Transform.from_matrix(m)
        inverse_t = Transform.inverse(t)

        result =
          p
          |> Transformable.apply_transform(t)
          |> Transformable.apply_transform(inverse_t)

        assert_equal_within_delta p, result
      end
    end

    property "applying a translation transformation moves the point coordinates" do
      forall {p, tx, ty, tz} <- {point3(), float(), float(), float()} do
        t = Transform.translate(tx, ty, tz)
        result = Transformable.apply_transform(p, t)
        assert_in_delta result.x, p.x + tx, @delta
        assert_in_delta result.y, p.y + ty, @delta
        assert_in_delta result.z, p.z + tz, @delta
      end
    end
  end
end
