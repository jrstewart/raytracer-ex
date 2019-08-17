defmodule Raytracer.SurfaceInteraction do
  @moduledoc """
  This module provides a set of function for working with a surface intersection of a particular
  point on a surface.
  """

  alias __MODULE__
  alias Raytracer.Model
  alias Raytracer.Geometry.{Normal3, Point3}

  @enforce_keys [:model, :normal, :point]
  defstruct [:model, :normal, :point]

  @type t :: %SurfaceInteraction{model: Model.t(), normal: Normal3.t(), point: Point3.t()}
end
