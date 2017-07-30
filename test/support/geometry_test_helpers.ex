defmodule Raytracer.GeometryTestHelpers do
  @moduledoc """
  This module provides convenience functions for testing geometry data such as
  matrices, vectors, and quaternions.
  """

  import ExUnit.Assertions, only: [assert_in_delta: 3]

  @doc """
  Asserts the elements of `value1` and `value2` are equal within `delta`.
  """
  def assert_equal_within_delta(value1, value2, delta \\ 1.0e-7) do
    do_assert_equal_within_delta(value1, value2, delta)
  end

  defp do_assert_equal_within_delta({m1_00, m1_01, m1_02, m1_03,
                                     m1_10, m1_11, m1_12, m1_13,
                                     m1_20, m1_21, m1_22, m1_23,
                                     m1_30, m1_31, m1_32, m1_33},
                                    {m2_00, m2_01, m2_02, m2_03,
                                     m2_10, m2_11, m2_12, m2_13,
                                     m2_20, m2_21, m2_22, m2_23,
                                     m2_30, m2_31, m2_32, m2_33},
                                    delta) do
    assert_in_delta m1_00, m2_00, delta
    assert_in_delta m1_01, m2_01, delta
    assert_in_delta m1_02, m2_02, delta
    assert_in_delta m1_03, m2_03, delta
    assert_in_delta m1_10, m2_10, delta
    assert_in_delta m1_11, m2_11, delta
    assert_in_delta m1_12, m2_12, delta
    assert_in_delta m1_13, m2_13, delta
    assert_in_delta m1_20, m2_20, delta
    assert_in_delta m1_21, m2_21, delta
    assert_in_delta m1_22, m2_22, delta
    assert_in_delta m1_23, m2_23, delta
    assert_in_delta m1_30, m2_30, delta
    assert_in_delta m1_31, m2_31, delta
    assert_in_delta m1_32, m2_32, delta
    assert_in_delta m1_33, m2_33, delta
  end
  defp do_assert_equal_within_delta({x1, y1, z1, w1}, {x2, y2, z2, w2}, delta) do
    assert_in_delta x1, x2, delta
    assert_in_delta y1, y2, delta
    assert_in_delta z1, z2, delta
    assert_in_delta w1, w2, delta
  end
  defp do_assert_equal_within_delta({x1, y1, z1}, {x2, y2, z2}, delta) do
    assert_in_delta x1, x2, delta
    assert_in_delta y1, y2, delta
    assert_in_delta z1, z2, delta
  end
end
