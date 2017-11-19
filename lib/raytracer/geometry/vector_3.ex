defmodule Raytracer.Geometry.Vector3 do
  @moduledoc """
  This module provides a set of functions for working with three dimensional
  vectors.
  """

  alias __MODULE__

  defstruct dx: 0.0, dy: 0.0, dz: 0.0

  @type t :: %Vector3{dx: number, dy: number, dz: number}

  @doc """
  Computes the length of `vector`.
  """
  @spec length(t) :: number
  def length(%Vector3{} = vector) do
    vector |> length_squared() |> :math.sqrt()
  end

  @doc """
  Computes the squared length of `vector`.
  """
  @spec length_squared(t) :: number
  def length_squared(%Vector3{} = vector) do
    vector.dx * vector.dx + vector.dy * vector.dy + vector.dz * vector.dz
  end
end
