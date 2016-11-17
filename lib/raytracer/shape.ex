defprotocol Raytracer.Shape do
  def compute_intersection(shape, ray)

  def compute_inward_normal(shape, point)

  def compute_outward_normal(shape, point)
end
