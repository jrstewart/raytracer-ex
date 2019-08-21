defmodule Raytracer.SurfaceInteraction do
  @moduledoc """
  This module provides a set of function for working with a surface intersection of a particular
  point on a surface.
  """

  alias __MODULE__
  alias Raytracer.Model
  alias Raytracer.Geometry.{Point3, Vector3}

  @enforce_keys [:model, :normal, :point]
  defstruct [:model, :normal, :point]

  @type t :: %SurfaceInteraction{model: Model.t(), normal: Vector3.t(), point: Point3.t()}
end
