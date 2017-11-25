defmodule Raytracer.Geometry.Ray3 do
  @moduledoc """
  This module provides a set of functions for working with three-dimensional
  rays represented by an origin point and a direction vector.
  """

  alias __MODULE__
  alias Raytracer.{Transform, Transformable}
  alias Raytracer.Geometry.{Point3, Vector3}

  defstruct origin: %Point3{}, direction: %Vector3{}

  @type t :: %Ray3{origin: Point3.t(), direction: Vector3.t()}

  @doc """
  Computes the point at `distance` on `ray` returning a tuple `{:ok, point}`
  where `point` is the computed point. `{:error, :none}` is returned if
  `distance` is less than 0.
  """
  @spec point_at(t(), number()) :: {atom(), Point3.t() | atom()}
  def point_at(_, distance) when distance < 0 do
    {:error, :none}
  end

  def point_at(%Ray3{} = ray, distance) do
    {:ok, ray.direction |> Vector3.multiply(distance) |> Vector3.add(ray.origin)}
  end

  defimpl Transformable do
    def apply_transform(%Ray3{} = ray, %Transform{} = transform) do
      %Ray3{
        origin: Transformable.apply_transform(ray.origin, transform),
        direction: Transformable.apply_transform(ray.direction, transform)
      }
    end
  end
end
