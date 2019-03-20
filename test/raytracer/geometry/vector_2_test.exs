defmodule Raytracer.Geometry.Vector2Test do
  use ExUnit.Case, async: true
  use PropCheck
  import Raytracer.{GeometryTestHelpers, Generators}
  alias Raytracer.Geometry.{Point2, Vector2}

  @delta 1.0e-7

  doctest Vector2

  describe "Raytracer.Geometry.Vector2.abs/1" do
    property "computes the absolute value of the vector components" do
      forall v <- vector2() do
        result = Vector2.abs(v)
        assert result.dx == if(v.dx >= 0.0, do: v.dx, else: -v.dx)
        assert result.dy == if(v.dy >= 0.0, do: v.dy, else: -v.dy)
      end
    end
  end

  describe "Raytracer.Geometry.Vector2.add/2" do
    property "subtracing one of the vectors from the resulting vector returns the other vector" do
      forall {v1, v2} <- {vector2(), vector2()} do
        result = Vector2.add(v1, v2)
        assert_in_delta result.dx - v2.dx, v1.dx, @delta
        assert_in_delta result.dy - v2.dy, v1.dy, @delta
      end
    end

    property "subtracing the vector from the resulting point returns the original point" do
      forall {v, p} <- {vector2(), point2()} do
        result = Vector2.add(v, p)
        assert_in_delta result.x - v.dx, p.x, @delta
        assert_in_delta result.y - v.dy, p.y, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Vector2.divide/2" do
    property "multiplying the resulting vector by the scalar returns the original vector" do
      forall {v, scalar} <- {vector2(), non_zero_float()} do
        result = Vector2.divide(v, scalar)
        assert_in_delta result.dx * scalar, v.dx, @delta
        assert_in_delta result.dy * scalar, v.dy, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Vector2.dot/2" do
    property "the dot product is commutative" do
      forall {v1, v2} <- {vector2(), vector2()} do
        assert_in_delta Vector2.dot(v1, v2), Vector2.dot(v2, v1), @delta
      end
    end

    property "the dot product is distributive" do
      forall {v1, v2, v3} <- {vector2(), vector2(), vector2()} do
        result1 = Vector2.dot(v1, Vector2.add(v2, v3))
        result2 = Vector2.dot(v1, v2) + Vector2.dot(v1, v3)
        assert_in_delta result1, result2, @delta
      end
    end

    property "the dot product is billinear" do
      forall {v1, v2, v3, scalar} <- {vector2(), vector2(), vector2(), float()} do
        result1 = Vector2.dot(v1, Vector2.add(Vector2.multiply(v2, scalar), v3))
        result2 = scalar * Vector2.dot(v1, v2) + Vector2.dot(v1, v3)
        assert_in_delta result1, result2, @delta
      end
    end

    property "associative law for scalar and dot product" do
      forall {v1, v2, scalar1, scalar2} <- {vector2(), vector2(), float(), float()} do
        result1 = Vector2.dot(Vector2.multiply(v1, scalar1), Vector2.multiply(v2, scalar2))
        result2 = scalar1 * scalar2 * Vector2.dot(v1, v2)
        assert_in_delta result1, result2, @delta
      end
    end

    property "the dot product of orthogonal vectors is 0" do
      forall value <- float() do
        v1 = %Vector2{dx: value, dy: 0.0}
        v2 = %Vector2{dx: 0.0, dy: value}
        assert_in_delta Vector2.dot(v1, v2), 0.0, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Vector2.length/1" do
    property "the length of the zero vector is 0" do
      v = %Vector2{dx: 0.0, dy: 0.0}
      assert Vector2.length(v) == 0.0
    end

    property "the length of a unit vector is 1" do
      forall v <- vector2() do
        v = Vector2.normalize(v)
        assert_in_delta Vector2.length(v), 1.0, @delta
      end
    end

    property "changing the direction of a vector does not change its length" do
      forall v <- vector2() do
        length1 = Vector2.length(v)
        length2 = %Vector2{dx: v.dy, dy: v.dx} |> Vector2.length()
        assert_in_delta length1, length2, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Vector2.length_squared/1" do
    property "the squared length of the zero vector is 0" do
      v = %Vector2{dx: 0.0, dy: 0.0}
      assert Vector2.length_squared(v) == 0.0
    end

    property "the squared length of a unit vector is 1" do
      forall v <- vector2() do
        v = Vector2.normalize(v)
        assert_in_delta Vector2.length_squared(v), 1.0, @delta
      end
    end

    property "changing the direction of a vector does not change its squared length" do
      forall v <- vector2() do
        length1 = Vector2.length_squared(v)
        length2 = %Vector2{dx: v.dy, dy: v.dx} |> Vector2.length_squared()
        assert_in_delta length1, length2, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Vector2.max_component/1" do
    property "returns the largest component value of a vector" do
      forall v <- vector2() do
        cond do
          v.dx > v.dy ->
            assert Vector2.max_component(v) == v.dx

          true ->
            assert Vector2.max_component(v) == v.dy
        end
      end
    end
  end

  describe "Raytracer.Geometry.Vector2.min_component/1" do
    property "returns the smallest component value of a vector" do
      forall v <- vector2() do
        cond do
          v.dx < v.dy ->
            assert Vector2.min_component(v) == v.dx

          true ->
            assert Vector2.min_component(v) == v.dy
        end
      end
    end
  end

  describe "Raytracer.Geometry.Vector2.multiply/2" do
    property "dividing the resulting vector by the scalar returns the original vector" do
      forall {v, scalar} <- {vector2(), non_zero_float()} do
        result = Vector2.multiply(v, scalar)
        assert_in_delta result.dx / scalar, v.dx, @delta
        assert_in_delta result.dy / scalar, v.dy, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Vector2.normalize/1" do
    property "a normalized vector has a length of 1" do
      forall v <- vector2() do
        assert_in_delta v |> Vector2.normalize() |> Vector2.length(), 1.0, @delta
      end
    end

    property "multiplying a normalized vector by its original length returns the original vector" do
      forall v <- vector2() do
        length = Vector2.length(v)
        assert_equal_within_delta v |> Vector2.normalize() |> Vector2.multiply(length), v
      end
    end
  end

  describe "Raytracer.Geometry.Vector2.subtract/2" do
    property "adding the second vector to the resulting vector returns the first vector" do
      forall {v1, v2} <- {vector2(), vector2()} do
        result = Vector2.subtract(v1, v2)
        assert_in_delta result.dx + v2.dx, v1.dx, @delta
        assert_in_delta result.dy + v2.dy, v1.dy, @delta
      end
    end
  end
end
