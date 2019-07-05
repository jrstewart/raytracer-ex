defprotocol Raytracer.Shape do
  @moduledoc """
  A protocol that defines an interface for working with shapes.
  """

  alias Raytracer.Geometry.{Normal3, Point3, Ray3}

  @doc """
  Computes the distance from the origin of `ray` to the intersection point of `shape`. If `ray` and
  `shape` do not intersect `nil` is returned.
  """
  @spec compute_intersection(t, Ray3.t()) :: nil | float
  def compute_intersection(shape, ray)

  @doc """
  Computes the inward pointing normal vector at `point` on `shape`.
  """
  @spec compute_inward_normal(t, Point3.t()) :: Normal3.t()
  def compute_inward_normal(shape, point)

  @doc """
  Computes the outward pointing normal vector at `point` on `shape`.
  """
  @spec compute_outward_normal(t, Point3.t()) :: Normal3.t()
  def compute_outward_normal(shape, point)
end
