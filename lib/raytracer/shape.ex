defprotocol Raytracer.Shape do
  alias Raytracer.Ray
  alias Raytracer.Point3
  alias Raytracer.Vector3

  @spec compute_intersection(t, Ray.t) :: nil | float
  def compute_intersection(shape, ray)

  @spec compute_inward_normal(t, Point3.t) :: Vector3.t
  def compute_inward_normal(shape, point)

  @spec compute_outward_normal(t, Point3.t) :: Vector3.t
  def compute_outward_normal(shape, point)
end
