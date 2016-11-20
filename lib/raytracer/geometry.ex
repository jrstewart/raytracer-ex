defmodule Raytracer.Geometry do
  @moduledoc """
  Collection of functions for performing geometric and math operations.
  """

  @doc """
  Linearly interpolates between `value1` and `value2` based on the value of `t`.
  If `t` is 0, then `value1` is returned. if `t` is 1 then `value2` is returned.
  """
  @spec lerp(number, number, number) :: number
  def lerp(value1, _value2, 0), do: value1

  def lerp(_value1, value2, 1), do: value2

  def lerp(value1, value2, t) do
    (1 - t) * value1 + t * value2
  end
end
