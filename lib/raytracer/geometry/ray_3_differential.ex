defmodule Raytracer.Geometry.Ray3Differential do
  @moduledoc """
  Ray differentials provide two auxiliary rays in addition to a primary ray to
  allow additional information to be used in computations such as antialiasing
  and texture mapping.
  """

  alias __MODULE__
  alias Raytracer.{Transform, Transformable}
  alias Raytracer.Geometry.{Point3, Ray3, Vector3}

  defstruct ray: %Ray3{},
            x_origin: %Point3{},
            y_origin: %Point3{},
            x_direction: %Vector3{},
            y_direction: %Vector3{},
            has_differentials?: false

  @type t :: %Ray3Differential{
          ray: Ray3.t(),
          x_origin: Point3.t(),
          y_origin: Point3.t(),
          x_direction: Vector3.t(),
          y_direction: Vector3.t(),
          has_differentials?: boolean()
        }

  @doc """
  Scales the auxiliary ray information of `ray_differential` by the given
  `scalar` value.
  """
  @spec scale(t(), number()) :: t()
  def scale(%Ray3Differential{} = ray_differential, scalar) do
    ray_differential
    |> Map.put(:x_origin, scale_point(ray_differential.ray, ray_differential.x_origin, scalar))
    |> Map.put(:y_origin, scale_point(ray_differential.ray, ray_differential.y_origin, scalar))
    |> Map.put(
      :x_direction,
      scale_vector(ray_differential.ray, ray_differential.x_direction, scalar)
    )
    |> Map.put(
      :y_direction,
      scale_vector(ray_differential.ray, ray_differential.y_direction, scalar)
    )
  end

  defp scale_point(ray, point, scalar) do
    point
    |> Point3.subtract(ray.origin)
    |> Vector3.multiply(scalar)
    |> Vector3.add(ray.origin)
  end

  defp scale_vector(ray, vector, scalar) do
    vector
    |> Vector3.subtract(ray.direction)
    |> Vector3.multiply(scalar)
    |> Vector3.add(ray.direction)
  end

  defimpl Transformable do
    def apply_transform(%Ray3Differential{} = ray_differential, %Transform{} = transform) do
      ray_differential
      |> Map.put(:ray, Transformable.apply_transform(ray_differential.ray, transform))
      |> Map.put(:x_origin, Transformable.apply_transform(ray_differential.x_origin, transform))
      |> Map.put(:y_origin, Transformable.apply_transform(ray_differential.y_origin, transform))
      |> Map.put(
        :x_direction,
        Transformable.apply_transform(ray_differential.x_direction, transform)
      )
      |> Map.put(
        :y_direction,
        Transformable.apply_transform(ray_differential.y_direction, transform)
      )
    end
  end
end
