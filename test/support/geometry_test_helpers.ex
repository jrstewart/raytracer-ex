defmodule Raytracer.GeometryTestHelpers do
  @moduledoc """
  This module provides convenience functions for testing geometry data such as
  matrices, vectors, and quaternions.
  """

  import ExUnit.Assertions, only: [assert_in_delta: 3]

  alias Raytracer.Geometry.{
    Matrix4x4,
    Point2,
    Point3,
    Quaternion,
    Vector2,
    Vector3
  }

  @doc """
  Asserts the elements of `value1` and `value2` are equal within `delta`.
  """
  def assert_equal_within_delta(value1, value2, delta \\ 1.0e-7) do
    do_assert_equal_within_delta(value1, value2, delta)
  end

  defp do_assert_equal_within_delta(%Matrix4x4{} = m1, %Matrix4x4{} = m2, delta) do
    assert_in_delta Matrix4x4.elem(m1, 0, 0), Matrix4x4.elem(m2, 0, 0), delta
    assert_in_delta Matrix4x4.elem(m1, 0, 1), Matrix4x4.elem(m2, 0, 1), delta
    assert_in_delta Matrix4x4.elem(m1, 0, 2), Matrix4x4.elem(m2, 0, 2), delta
    assert_in_delta Matrix4x4.elem(m1, 0, 3), Matrix4x4.elem(m2, 0, 3), delta
    assert_in_delta Matrix4x4.elem(m1, 1, 0), Matrix4x4.elem(m2, 1, 0), delta
    assert_in_delta Matrix4x4.elem(m1, 1, 1), Matrix4x4.elem(m2, 1, 1), delta
    assert_in_delta Matrix4x4.elem(m1, 1, 2), Matrix4x4.elem(m2, 1, 2), delta
    assert_in_delta Matrix4x4.elem(m1, 1, 3), Matrix4x4.elem(m2, 1, 3), delta
    assert_in_delta Matrix4x4.elem(m1, 2, 0), Matrix4x4.elem(m2, 2, 0), delta
    assert_in_delta Matrix4x4.elem(m1, 2, 1), Matrix4x4.elem(m2, 2, 1), delta
    assert_in_delta Matrix4x4.elem(m1, 2, 2), Matrix4x4.elem(m2, 2, 2), delta
    assert_in_delta Matrix4x4.elem(m1, 2, 3), Matrix4x4.elem(m2, 2, 3), delta
    assert_in_delta Matrix4x4.elem(m1, 3, 0), Matrix4x4.elem(m2, 3, 0), delta
    assert_in_delta Matrix4x4.elem(m1, 3, 1), Matrix4x4.elem(m2, 3, 1), delta
    assert_in_delta Matrix4x4.elem(m1, 3, 2), Matrix4x4.elem(m2, 3, 2), delta
    assert_in_delta Matrix4x4.elem(m1, 3, 3), Matrix4x4.elem(m2, 3, 3), delta
  end

  defp do_assert_equal_within_delta(%Point2{} = p1, %Point2{} = p2, delta) do
    assert_in_delta p1.x, p2.x, delta
    assert_in_delta p1.y, p2.y, delta
  end

  defp do_assert_equal_within_delta(%Point3{} = p1, %Point3{} = p2, delta) do
    assert_in_delta p1.x, p2.x, delta
    assert_in_delta p1.y, p2.y, delta
    assert_in_delta p1.z, p2.z, delta
  end

  defp do_assert_equal_within_delta(%Quaternion{} = q1, %Quaternion{} = q2, delta) do
    assert_in_delta q1.x, q2.x, delta
    assert_in_delta q1.y, q2.y, delta
    assert_in_delta q1.z, q2.z, delta
    assert_in_delta q1.w, q2.w, delta
  end

  defp do_assert_equal_within_delta(%Vector2{} = v1, %Vector2{} = v2, delta) do
    assert_in_delta v1.dx, v2.dx, delta
    assert_in_delta v1.dy, v2.dy, delta
  end

  defp do_assert_equal_within_delta(%Vector3{} = v1, %Vector3{} = v2, delta) do
    assert_in_delta v1.dx, v2.dx, delta
    assert_in_delta v1.dy, v2.dy, delta
    assert_in_delta v1.dz, v2.dz, delta
  end
end
