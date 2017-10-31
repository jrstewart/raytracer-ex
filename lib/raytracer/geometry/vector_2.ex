defmodule Raytracer.Geometry.Vector2 do
  @moduledoc """
  This module provides a set of functions for working with two dimensional
  vectors.
  """

  alias __MODULE__

  defstruct dx: 0.0, dy: 0.0

  @type t :: %Vector2{dx: number, dy: number}

  @doc """
  Computes the length of `vector`.
  """
  @spec length(t) :: number
  def length(%Vector2{} = vector) do
    vector |> length_squared() |> :math.sqrt()
  end

  @doc """
  Computes the squared length of `vector`.
  """
  @spec length_squared(t) :: number
  def length_squared(%Vector2{} = vector) do
    vector.dx * vector.dx + vector.dy * vector.dy
  end
end
