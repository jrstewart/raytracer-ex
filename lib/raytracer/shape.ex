defprotocol Raytracer.Shape do
  @moduledoc """
  A protocol that defines an interface for working with shapes.
  """

  alias Raytracer.Geometry.Ray
  alias Raytracer.Geometry.Point
  alias Raytracer.Geometry.Vector


  @doc """
  Computes the distance from the origin of `ray` to the intersection point of
  `shape`. If `ray` and `shape` do not intersect `nil` is returned.
  """
  @spec compute_intersection(t, Ray.t) :: nil | float
  def compute_intersection(shape, ray)


  @doc """
  Computes the inward pointing normal vector at `point` on `shape`.
  """
  @spec compute_inward_normal(t, Point.point3_t) :: Vector.vector3_t
  def compute_inward_normal(shape, point)


  @doc """
  Computes the outward pointing normal vector at `point` on `shape`.
  """
  @spec compute_outward_normal(t, Point.point3_t) :: Vector.vector3_t
  def compute_outward_normal(shape, point)
end
