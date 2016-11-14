defprotocol Raytracer.Shape do
  @doc """
  Computes the distance from the origin of `ray` to the intersection point of
  `shape`. If `ray` and `shape` do not intersect `nil` is returned.
  """
  def compute_intersection(shape, ray)

  @doc """
  Computes the inward pointing normal vector at `point` on `shape`.
  """
  def compute_inward_normal(shape, point)

  @doc """
  Computes the outward pointing normal vector at `point` on `shape`.
  """
  def compute_outward_normal(shape, point)
end
