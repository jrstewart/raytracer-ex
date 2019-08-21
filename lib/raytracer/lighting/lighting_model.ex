defprotocol Raytracer.Lighting.LightingModel do
  @moduledoc false

  alias Raytracer.{ColorRGB, Scene, SurfaceInteraction}
  alias Raytracer.Geometry.Vector3

  @spec compute_color(Vector3.t(), SurfaceInteraction.t(), Scene.t()) :: ColorRGB.t()
  def compute_color(view_direction, surface_interaction, scene)
end
