defmodule Raytracer.Lighting.CookTorranceLightingModel do
  @moduledoc false

  alias Raytracer.{ColorRGB, Material, Shape}
  alias Raytracer.Geometry.{Ray3, Vector3}
  alias Raytracer.Lighting.{Light, LightingModel}

  @behaviour LightingModel

  @impl LightingModel
  def compute_color(view_direction, surface_interaction, scene) do
    index_of_refraction = Material.index_of_refraction(surface_interaction.model.material)

    Enum.reduce(scene.light_sources, ColorRGB.black(), fn light_source, acc ->
      light_source_direction =
        Light.compute_direction(light_source.light, surface_interaction.point)

      # Compute the cosine of the angle between the light and the surface normal (incident angle)
      # and determine if the model's shape is shadowed by another shape in the scene.
      cos_theta_i = Vector3.dot(surface_interaction.normal, light_source_direction)
      is_shadowed = is_shadowed?(surface_interaction, scene, light_source_direction)

      # If the light is on the other side of the shape from the surface point or if it is shadowed
      # by another shape don't compute the color. Otherwise compute the color at the surface point.
      light_color =
        if cos_theta_i <= 0.0 || is_shadowed do
          ColorRGB.black()
        else
          solid_angle = Light.compute_solid_angle(light_source.light, surface_interaction.point)

          red =
            compute_intensity(
              view_direction,
              surface_interaction,
              light_source_direction,
              cos_theta_i,
              index_of_refraction,
              surface_interaction.model.material.normal_reflectances.red,
              light_source.color.red,
              solid_angle
            )

          green =
            compute_intensity(
              view_direction,
              surface_interaction,
              light_source_direction,
              cos_theta_i,
              index_of_refraction,
              surface_interaction.model.material.normal_reflectances.green,
              light_source.color.green,
              solid_angle
            )

          blue =
            compute_intensity(
              view_direction,
              surface_interaction,
              light_source_direction,
              cos_theta_i,
              index_of_refraction,
              surface_interaction.model.material.normal_reflectances.blue,
              light_source.color.blue,
              solid_angle
            )

          %ColorRGB{red: red, green: green, blue: blue}
        end

      ColorRGB.add(acc, light_color)
    end)
  end

  defp is_shadowed?(surface_interaction, scene, light_source_direction) do
    Enum.any?(scene.models, fn model ->
      if model.shape !== surface_interaction.model.shape do
        ray = %Ray3{origin: surface_interaction.point, direction: light_source_direction}
        Shape.compute_intersection(model.shape, ray)
      end
    end)
  end

  defp compute_intensity(
         view_direction,
         surface_interaction,
         light_source_direction,
         cos_theta_i,
         index_of_refaction,
         normal_reflectances,
         light_color_value,
         solid_angle
       ) do
    Enum.reduce(normal_reflectances, 0.0, fn nr, acc ->
      brdf =
        compute_brdf(
          view_direction,
          surface_interaction,
          light_source_direction,
          cos_theta_i,
          index_of_refaction,
          nr
        )

      acc + brdf * light_color_value * cos_theta_i * solid_angle
    end) / length(normal_reflectances)
  end

  defp compute_brdf(
         view_direction,
         surface_interaction,
         light_source_direction,
         cos_theta_i,
         index_of_refraction,
         normal_reflectance
       ) do
    frannel_color = compute_frannel_color(cos_theta_i, index_of_refraction)

    halfway_vector =
      light_source_direction
      |> Vector3.add(view_direction)
      |> Vector3.normalize()

    normal_dot_light = Vector3.dot(surface_interaction.normal, light_source_direction)
    normal_dot_view = Vector3.dot(view_direction, surface_interaction.normal)
    normal_dot_halfway = Vector3.dot(surface_interaction.normal, halfway_vector)
    view_dot_halfway = Vector3.dot(view_direction, halfway_vector)

    masking_value =
      compute_masking_value(
        normal_dot_light,
        normal_dot_view,
        normal_dot_halfway,
        view_dot_halfway
      )

    material = surface_interaction.model.material
    mdv = compute_microfacet_distribution_value(material.shininess, normal_dot_halfway)

    specular =
      frannel_color * :math.pi() * (mdv * masking_value / (normal_dot_light * normal_dot_view))

    material.diffuse * normal_reflectance + material.specular * specular
  end

  defp compute_frannel_color(cos_theta_i, index_of_refraction) do
    # Compute the frannel color for the given wavelength (normal reflectance). The formula for
    # computing the frannel color is
    #   F = 1/2 * (g - c)^2 / (g + c)^2 * [1 + (c * (g + c) - 1)^2 / (c * (g - c) - 1)^2]
    #   c = cos(theta_i)
    #   g = sqrt(eta^2 + c^2 - 1)
    #   eta = 1 + sqrt(normal_reflectance) / 1 - sqrt(normal_reflectance)

    g = :math.sqrt(:math.pow(index_of_refraction, 2) + :math.pow(cos_theta_i, 2) - 1.0)

    0.5 * (:math.pow(g - cos_theta_i, 2) / :math.pow(g + cos_theta_i, 2)) *
      (1.0 +
         :math.pow(cos_theta_i * (g + cos_theta_i) - 1, 2) /
           :math.pow(cos_theta_i * (g - cos_theta_i) + 1, 2))
  end

  defp compute_masking_value(
         normal_dot_light,
         normal_dot_view,
         normal_dot_halfway,
         view_dot_halfway
       ) do
    # Compute the value of the masking produced by the microfacets of the surface. This value will
    # be the minimum of the masking value, the self-shadowing value of the surface, and the value 1.

    masking_value = 2.0 * normal_dot_halfway * normal_dot_view / view_dot_halfway
    self_shadow_value = 2.0 * normal_dot_halfway * normal_dot_light / view_dot_halfway

    cond do
      masking_value < self_shadow_value && masking_value < 1.0 ->
        masking_value

      self_shadow_value < masking_value && self_shadow_value < 1.0 ->
        self_shadow_value

      true ->
        1.0
    end
  end

  defp compute_microfacet_distribution_value(shininess, normal_dot_halfway) do
    # Compute the fraction of the microfacets which reflect light directly towards the viewer. The
    # formula for computing the microfacet distribution is
    #   D(alpha) = e^(-1 * (tan(alpha / m))^2) / (m^2 * cos^4(alpha))
    #   m = shininess value of the surface
    #   alpha = angle between the surface normal and the halfway vector

    alpha = :math.acos(normal_dot_halfway)

    :math.exp(-1.0 * :math.pow(:math.tan(alpha) / shininess, 2)) /
      (:math.pow(shininess, 2) * :math.pow(:math.cos(alpha), 4))
  end

  # @spec compute_reflected_light_direction(SurfaceInteraction.t(), Vector3.t()) :: Vector3.t()
  # def compute_reflected_light_direction(surface_interaction, light_source_direction) do
  #   {parallel, perpendicular} =
  #     Vector3.decompose(surface_interaction.normal, light_source_direction)

  #   perpendicular
  #   |> Vector3.negate()
  #   |> Vector3.add(parallel)
  #   |> Vector3.normalize()
  # end
end
