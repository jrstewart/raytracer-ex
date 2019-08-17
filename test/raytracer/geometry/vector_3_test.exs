defmodule Raytracer.Geometry.Vector3Test do
  use ExUnit.Case, async: true
  use PropCheck
  import Raytracer.{GeometryTestHelpers, Generators}
  alias Raytracer.{Transform, Transformable}
  alias Raytracer.Geometry.{Normal3, Point3, Vector3}

  @delta 1.0e-7

  doctest Vector3

  describe "Raytracer.Geometry.Vector3.abs/1" do
    property "computes the absolute value of the vector components" do
      forall v <- vector3() do
        result = Vector3.abs(v)
        assert result.dx == if(v.dx >= 0.0, do: v.dx, else: -v.dx)
        assert result.dy == if(v.dy >= 0.0, do: v.dy, else: -v.dy)
        assert result.dz == if(v.dz >= 0.0, do: v.dz, else: -v.dz)
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.add/2" do
    property "subtracing one of the vectors from the resulting vector returns the other vector" do
      forall {v1, v2} <- {vector3(), vector3()} do
        result = Vector3.add(v1, v2)
        assert_in_delta result.dx - v2.dx, v1.dx, @delta
        assert_in_delta result.dy - v2.dy, v1.dy, @delta
        assert_in_delta result.dz - v2.dz, v1.dz, @delta
      end
    end

    property "subtracing the vector from the resulting point returns the original point" do
      forall {v, p} <- {vector3(), point3()} do
        result = Vector3.add(v, p)
        assert_in_delta result.x - v.dx, p.x, @delta
        assert_in_delta result.y - v.dy, p.y, @delta
        assert_in_delta result.z - v.dz, p.z, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.cross/2" do
    property "cross products of standard basis vectors" do
      i = %Vector3{dx: 1.0, dy: 0.0, dz: 0.0}
      j = %Vector3{dx: 0.0, dy: 1.0, dz: 0.0}
      k = %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}

      assert_equal_within_delta Vector3.cross(i, j), k
      assert_equal_within_delta Vector3.cross(j, k), i
      assert_equal_within_delta Vector3.cross(k, i), j

      assert_equal_within_delta Vector3.cross(j, i), Vector3.negate(k)
      assert_equal_within_delta Vector3.cross(k, j), Vector3.negate(i)
      assert_equal_within_delta Vector3.cross(i, k), Vector3.negate(j)
    end

    property "a vector crossed with itself returns the zero vector" do
      forall v <- vector3() do
        assert_equal_within_delta Vector3.cross(v, v), Vector3.zero()
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.decompose/2" do
    property "adding the parallel and perpendicular vectors returns the original vector" do
      forall {v1, v2} <- {non_zero_vector3(), non_zero_vector3()} do
        {parallel, perpendicular} = Vector3.decompose(v1, v2)
        assert_equal_within_delta Vector3.add(parallel, perpendicular), v2
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.divide/2" do
    property "multiplying the resulting vector by the scalar returns the original vector" do
      forall {v, scalar} <- {vector3(), non_zero_float()} do
        result = Vector3.divide(v, scalar)
        assert_in_delta result.dx * scalar, v.dx, @delta
        assert_in_delta result.dy * scalar, v.dy, @delta
        assert_in_delta result.dz * scalar, v.dz, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.dot/2" do
    property "the dot product is commutative" do
      forall {v1, v2} <- {vector3(), vector3()} do
        assert_in_delta Vector3.dot(v1, v2), Vector3.dot(v2, v1), @delta
      end
    end

    property "the dot product is distributive" do
      forall {v1, v2, v3} <- {vector3(), vector3(), vector3()} do
        result1 = Vector3.dot(v1, Vector3.add(v2, v3))
        result2 = Vector3.dot(v1, v2) + Vector3.dot(v1, v3)
        assert_in_delta result1, result2, @delta
      end
    end

    property "the dot product is billinear" do
      forall {v1, v2, v3, scalar} <- {vector3(), vector3(), vector3(), float()} do
        result1 = Vector3.dot(v1, Vector3.add(Vector3.multiply(v2, scalar), v3))
        result2 = scalar * Vector3.dot(v1, v2) + Vector3.dot(v1, v3)
        assert_in_delta result1, result2, @delta
      end
    end

    property "associative law for scalar and dot product" do
      forall {v1, v2, scalar1, scalar2} <- {vector3(), vector3(), float(), float()} do
        result1 = Vector3.dot(Vector3.multiply(v1, scalar1), Vector3.multiply(v2, scalar2))
        result2 = scalar1 * scalar2 * Vector3.dot(v1, v2)
        assert_in_delta result1, result2, @delta
      end
    end

    property "the dot product of orthogonal vectors is 0" do
      forall value <- float() do
        v1 = %Vector3{dx: value, dy: 0.0, dz: 0.0}
        v2 = %Vector3{dx: 0.0, dy: value, dz: 0.0}
        v3 = %Vector3{dx: 0.0, dy: 0.0, dz: value}
        assert_in_delta Vector3.dot(v1, v2), 0.0, @delta
        assert_in_delta Vector3.dot(v1, v3), 0.0, @delta
        assert_in_delta Vector3.dot(v2, v3), 0.0, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.length/1" do
    property "the length of the zero vector is 0" do
      v = %Vector3{dx: 0.0, dy: 0.0, dz: 0.0}
      assert Vector3.length(v) == 0.0
    end

    property "the length of a unit vector is 1" do
      forall v <- vector3() do
        v = Vector3.normalize(v)
        assert_in_delta Vector3.length(v), 1.0, @delta
      end
    end

    property "changing the direction of a vector does not change its length" do
      forall v <- vector3() do
        length1 = Vector3.length(v)
        length2 = %Vector3{dx: v.dy, dy: v.dz, dz: v.dx} |> Vector3.length()
        length3 = %Vector3{dx: v.dz, dy: v.dx, dz: v.dy} |> Vector3.length()
        assert_in_delta length1, length2, @delta
        assert_in_delta length1, length3, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.length_squared/1" do
    property "the squared length of the zero vector is 0" do
      v = %Vector3{dx: 0.0, dy: 0.0, dz: 0.0}
      assert Vector3.length_squared(v) == 0.0
    end

    property "the squared length of a unit vector is 1" do
      forall v <- vector3() do
        v = Vector3.normalize(v)
        assert_in_delta Vector3.length_squared(v), 1.0, @delta
      end
    end

    property "changing the direction of a vector does not change its squared length" do
      forall v <- vector3() do
        length1 = Vector3.length_squared(v)
        length2 = %Vector3{dx: v.dy, dy: v.dz, dz: v.dx} |> Vector3.length_squared()
        length3 = %Vector3{dx: v.dz, dy: v.dx, dz: v.dy} |> Vector3.length_squared()
        assert_in_delta length1, length2, @delta
        assert_in_delta length1, length3, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.max_component/1" do
    property "returns the largest component value of a vector" do
      forall v <- vector3() do
        cond do
          v.dx > v.dy && v.dx > v.dz ->
            assert Vector3.max_component(v) == v.dx

          v.dy > v.dz ->
            assert Vector3.max_component(v) == v.dy

          true ->
            assert Vector3.max_component(v) == v.dz
        end
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.min_component/1" do
    property "returns the smallest component value of a vector" do
      forall v <- vector3() do
        cond do
          v.dx < v.dy && v.dx < v.dz ->
            assert Vector3.min_component(v) == v.dx

          v.dy < v.dz ->
            assert Vector3.min_component(v) == v.dy

          true ->
            assert Vector3.min_component(v) == v.dz
        end
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.multiply/2" do
    property "dividing the resulting vector by the scalar returns the original vector" do
      forall {v, scalar} <- {vector3(), non_zero_float()} do
        result = Vector3.multiply(v, scalar)
        assert_in_delta result.dx / scalar, v.dx, @delta
        assert_in_delta result.dy / scalar, v.dy, @delta
        assert_in_delta result.dz / scalar, v.dz, @delta
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.normalize/1" do
    property "a normalized vector has a length of 1" do
      forall v <- vector3() do
        assert_in_delta v |> Vector3.normalize() |> Vector3.length(), 1.0, @delta
      end
    end

    property "multiplying a normalized vector by its original length returns the original vector" do
      forall v <- vector3() do
        length = Vector3.length(v)
        assert_equal_within_delta v |> Vector3.normalize() |> Vector3.multiply(length), v
      end
    end
  end

  describe "Raytracer.Geometry.Vector3.subtract/2" do
    property "adding the second vector to the resulting vector returns the first vector" do
      forall {v1, v2} <- {vector3(), vector3()} do
        result = Vector3.subtract(v1, v2)
        assert_in_delta result.dx + v2.dx, v1.dx, @delta
        assert_in_delta result.dy + v2.dy, v1.dy, @delta
        assert_in_delta result.dz + v2.dz, v1.dz, @delta
      end
    end
  end

  describe "Raytracer.Transformable.apply_transform/2" do
    property "applying the inverse transformation to a transformed vector produces the original vector" do
      forall {v, m} <- {vector3(), affine_matrix4x4()} do
        t = Transform.from_matrix(m)
        inverse_t = Transform.inverse(t)

        result =
          v
          |> Transformable.apply_transform(t)
          |> Transformable.apply_transform(inverse_t)

        assert_equal_within_delta v, result
      end
    end

    property "applying a scale transformation scales the vector components" do
      forall {v, sx, sy, sz} <- {vector3(), non_zero_float(), non_zero_float(), non_zero_float()} do
        t = Transform.scale(sx, sy, sz)
        result = Transformable.apply_transform(v, t)
        assert_in_delta result.dx, v.dx * sx, @delta
        assert_in_delta result.dy, v.dy * sy, @delta
        assert_in_delta result.dz, v.dz * sz, @delta
      end
    end
  end
end
