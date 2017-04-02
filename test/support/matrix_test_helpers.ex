defmodule Raytracer.MatrixTestHelpers do
  @moduledoc """
  This module provides convenience functions for testing matrix data.
  """

  import ExUnit.Assertions, only: [assert_in_delta: 3]

  @doc """
  Asserts the elements of `m1` and `m2` are equal within `delta`.
  """
  def assert_matrices_equal_within_delta(m1, m2, delta \\ 1.0e-7) do
    for i <- 0..15 do
      assert_in_delta elem(m1, i), elem(m2, i), delta
    end
  end
end
