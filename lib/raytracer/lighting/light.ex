defprotocol Raytracer.Lighting.Light do
  alias Raytracer.Geometry.{Point3, Vector3}

  @spec compute_direction(t(), Point3.t()) :: Vector3.t()
  def compute_direction(light, point)

  @spec compute_solid_angle(t(), Point3.t()) :: float()
  def compute_solid_angle(light, point)
end
