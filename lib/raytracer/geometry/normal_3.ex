defmodule Raytracer.Geometry.Normal3 do
  @moduledoc """
  This module provides a set of functions for working with three dimensional
  surface normal vectors. A surface normal is a vector that is perpendicular to
  a surface at a specific position. Note that a surface normal is not
  necessarily a normalized vector.
  """

  alias __MODULE__

  defstruct dx: 0.0, dy: 0.0, dz: 0.0

  @type t :: %Normal3{dx: number, dy: number, dz: number}
end
