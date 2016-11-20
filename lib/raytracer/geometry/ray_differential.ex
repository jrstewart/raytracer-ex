defmodule Raytracer.Geometry.RayDifferential do
  alias Raytracer.Geometry.{Ray, Point3, Vector3}

  defstruct [
    ray: %Ray{},
    x_origin: %Point3{},
    y_origin: %Point3{},
    x_direction: %Vector3{},
    y_direction: %Vector3{},
    has_differentials?: false,
  ]

  @type t :: %__MODULE__{
    ray: Ray.t,
    x_origin: Point3.t,
    y_origin: Point3.t,
    x_direction: Vector3.t,
    y_direction: Vector3.t,
    has_differentials?: boolean,
  }

  @spec scale(t, float) :: t
  def scale(
    %__MODULE__{
      ray: ray,
      x_origin: x_origin,
      y_origin: y_origin,
      x_direction: x_direction,
      y_direction: y_direction,
    } = ray_differential,
    scalar
  ) do
    ray_differential
    |> Map.put(:x_origin, scale_point(ray, x_origin, scalar))
    |> Map.put(:y_origin, scale_point(ray, y_origin, scalar))
    |> Map.put(:x_direction, scale_vector(ray, x_direction, scalar))
    |> Map.put(:y_direction, scale_vector(ray, y_direction, scalar))
  end

  defp scale_point(%Ray{origin: origin}, point, scalar) do
    point
    |> Point3.subtract(origin)
    |> Vector3.multiply(scalar)
    |> Vector3.add(origin)
  end

  defp scale_vector(%Ray{direction: direction}, vector, scalar) do
    vector
    |> Vector3.subtract(direction)
    |> Vector3.multiply(scalar)
    |> Vector3.add(direction)
  end
end
