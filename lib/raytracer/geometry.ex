defmodule Raytracer.Geometry do
  @moduledoc """
  Collection of functions for performing geometric and math operations.
  """

  @degrees_to_radians :math.pi() / 180.0
  @radians_to_degrees 180.0 / :math.pi()

  @doc """
  Check if `value` is between `min_value` and `max_value`. If `value` is less than `min_value` then
  `min_value` is returned. If `value` is greater than `max_value` then `max_value` is returned.
  Otherwise, `value` is returned.
  """
  @spec clamp(number, number, number) :: number
  def clamp(value, min_value, _) when value < min_value, do: min_value
  def clamp(value, _, max_value) when value > max_value, do: max_value
  def clamp(value, _, _), do: value

  @doc """
  Converts `degrees` to radians.
  """
  @spec degrees_to_radians(float) :: float
  def degrees_to_radians(degrees), do: @degrees_to_radians * degrees

  @doc """
  Linearly interpolates between `value1` and `value2` based on the value of `t`. If `t` is 0, then
  `value1` is returned. if `t` is 1 then `value2` is returned.
  """
  @spec lerp(number, number, float) :: float
  def lerp(value1, _, t) when t == 0.0, do: value1
  def lerp(_, value2, 1.0), do: value2
  def lerp(value1, value2, t), do: (1 - t) * value1 + t * value2

  @doc """
  Converts `radians` to degrees.
  """
  @spec radians_to_degrees(float) :: float
  def radians_to_degrees(radians), do: @radians_to_degrees * radians
end
