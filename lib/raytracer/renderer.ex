defmodule Raytracer.Renderer do
  @moduledoc false

  alias __MODULE__
  alias Raytracer.{Camera, ColorRGB, Parser, Scene, Shape, SurfaceInteraction}
  alias Raytracer.Geometry.{Point3, Ray3, Vector3}
  alias Raytracer.Lighting.CookTorranceLightingModel

  @behaviour Parser

  @enforce_keys [:camera]
  defstruct [
    :camera,
    ambient_light_color: ColorRGB.black(),
    attenuation_cutoff: 0.1,
    background_color: ColorRGB.black(),
    global_rgb_scale: 1.0,
    max_recursive_depth: 4,
    supersample_size: 0
  ]

  @type t :: %Renderer{
          camera: Camera.t(),
          ambient_light_color: ColorRGB.t(),
          attenuation_cutoff: float(),
          background_color: ColorRGB.t(),
          global_rgb_scale: float(),
          max_recursive_depth: integer(),
          supersample_size: integer()
        }

  @k2_filter [
    1.0 / 16.0,
    1.0 / 8.0,
    1.0 / 16.0,
    1.0 / 8.0,
    1.0 / 4.0,
    1.0 / 8.0,
    1.0 / 16.0,
    1.0 / 8.0,
    1.0 / 16.0
  ]

  @k4_filter [
    1.0 / 81.0,
    2.0 / 81.0,
    1.0 / 27.0,
    2.0 / 81.0,
    1.0 / 81.0,
    2.0 / 81.0,
    4.0 / 81.0,
    2.0 / 27.0,
    4.0 / 81.0,
    2.0 / 81.0,
    1.0 / 27.0,
    2.0 / 27.0,
    1.0 / 9.0,
    2.0 / 27.0,
    1.0 / 27.0,
    2.0 / 81.0,
    4.0 / 81.0,
    2.0 / 27.0,
    4.0 / 81.0,
    2.0 / 81.0,
    1.0 / 81.0,
    2.0 / 81.0,
    1.0 / 27.0,
    2.0 / 81.0,
    1.0 / 81.0
  ]

  @k6_filter [
    1.0 / 256.0,
    1.0 / 128.0,
    3.0 / 256.0,
    1.0 / 64.0,
    3.0 / 256.0,
    1.0 / 128.0,
    1.0 / 256.0,
    1.0 / 128.0,
    1.0 / 64.0,
    3.0 / 128.0,
    1.0 / 32.0,
    3.0 / 128.0,
    1.0 / 64.0,
    1.0 / 128.0,
    3.0 / 256.0,
    3.0 / 128.0,
    9.0 / 256.0,
    3.0 / 64.0,
    9.0 / 256.0,
    3.0 / 128.0,
    3.0 / 256.0,
    1.0 / 64.0,
    1.0 / 32.0,
    3.0 / 64.0,
    1.0 / 16.0,
    3.0 / 64.0,
    1.0 / 32.0,
    1.0 / 64.0,
    3.0 / 256.0,
    3.0 / 128.0,
    9.0 / 256.0,
    3.0 / 64.0,
    9.0 / 256.0,
    3.0 / 128.0,
    3.0 / 256.0,
    1.0 / 128.0,
    1.0 / 64.0,
    3.0 / 128.0,
    1.0 / 32.0,
    3.0 / 128.0,
    1.0 / 64.0,
    1.0 / 128.0,
    1.0 / 256.0,
    1.0 / 128.0,
    3.0 / 256.0,
    1.0 / 64.0,
    3.0 / 256.0,
    1.0 / 128.0,
    1.0 / 256.0
  ]

  @doc """
  Builds a Renderer struct from the data in the given file `path`.
  """
  @spec from_file(Path.t()) :: {:ok, t()} | {:error, File.posix()}
  def from_file(path) do
    with {:ok, data} <- File.read(path),
         {:ok, data} <- Jason.decode(data) do
      Renderer.parse(data)
    else
      error ->
        error
    end
  end

  @spec render_scene(t(), Scene.t()) :: {:ok, list(ColorRGB.t())} | {:error, String.t()}
  def render_scene(renderer, scene) do
    pixel_grid = Camera.pixel_grid(renderer.camera)
    pixel_size = Camera.pixel_size(renderer.camera)

    colors =
      pixel_grid
      |> Enum.with_index()
      |> Flow.from_enumerable()
      |> Flow.map(fn {pixel, index} ->
        {render_pixel(renderer, scene, pixel, pixel_size, renderer.supersample_size), index}
      end)
      |> Enum.to_list()
      |> Enum.sort(&(elem(&1, 1) < elem(&2, 1)))
      |> Enum.map(&elem(&1, 0))

    {:ok, colors}
  end

  defp render_pixel(renderer, scene, pixel_point, _pixel_size, 0) do
    ray = %Ray3{
      origin: renderer.camera.eye,
      direction: pixel_point |> Point3.subtract(renderer.camera.eye) |> Vector3.normalize()
    }

    trace_ray(renderer, scene, ray, 1.0, 0)
  end

  defp render_pixel(renderer, scene, pixel_point, {pixel_width, pixel_height}, sample_size)
       when sample_size in [2, 4, 6] do
    offset = 1.0 / sample_size

    for u_sample <- 0..sample_size, v_sample <- 0..sample_size do
      h = Vector3.multiply(renderer.camera.coords.u_axis, offset * u_sample * pixel_width)
      v = Vector3.multiply(renderer.camera.coords.v_axis, offset * v_sample * pixel_height)
      sample_point = pixel_point |> Point3.add(h) |> Point3.add(v)

      ray = %Ray3{
        origin: renderer.camera.eye,
        direction: sample_point |> Point3.subtract(renderer.camera.eye) |> Vector3.normalize()
      }

      trace_ray(renderer, scene, ray, 1.0, 0)
    end
    |> Enum.zip(filter_for_sample_size(sample_size))
    |> Enum.reduce(ColorRGB.black(), fn {color, filter}, acc ->
      color |> ColorRGB.multiply(filter) |> ColorRGB.add(acc)
    end)
  end

  defp trace_ray(renderer, scene, ray, attenuation, depth) do
    case find_intersecting_model(ray, scene.models) do
      nil ->
        if depth == 0, do: renderer.background_color, else: ColorRGB.black()

      {distance, model} ->
        point = Point3.add(ray.origin, Vector3.multiply(ray.direction, distance))
        view_direction = renderer.camera.eye |> Point3.subtract(point) |> Vector3.normalize()
        normal = Shape.compute_outward_normal(model.shape, point)
        si = %SurfaceInteraction{model: model, normal: normal, point: point}
        color = CookTorranceLightingModel.compute_color(view_direction, si, scene)

        reflected_color =
          if model.material.reflected_scale_factor > 0.0 &&
               model.material.reflected_scale_factor * attenuation > renderer.attenuation_cutoff &&
               depth < renderer.max_recursive_depth do
            reflected_ray = %Ray3{
              origin: point,
              direction: compute_reflected_ray_direction(si, ray)
            }

            renderer
            |> trace_ray(
              scene,
              reflected_ray,
              attenuation * model.material.reflected_scale_factor,
              depth + 1
            )
            |> ColorRGB.multiply(model.material.reflected_scale_factor)
          else
            ColorRGB.black()
          end

        color
        |> ColorRGB.multiply(1.0 - model.material.reflected_scale_factor)
        |> ColorRGB.add(reflected_color)
        |> ColorRGB.multiply(renderer.global_rgb_scale)
    end
  end

  defp find_intersecting_model(ray, models), do: find_intersecting_model(ray, models, nil)

  defp find_intersecting_model(_ray, [], current), do: current

  defp find_intersecting_model(ray, [model | rest], nil) do
    distance = Shape.compute_intersection(model.shape, ray)

    current =
      if distance && distance >= 0.0 do
        {distance, model}
      else
        nil
      end

    find_intersecting_model(ray, rest, current)
  end

  defp find_intersecting_model(ray, [model | rest], {current_distance, _} = current) do
    distance = Shape.compute_intersection(model.shape, ray)

    current =
      if distance && distance >= 0.0 && distance < current_distance do
        {distance, model}
      else
        current
      end

    find_intersecting_model(ray, rest, current)
  end

  defp compute_reflected_ray_direction(surface_interaction, ray) do
    {parallel, perpendicular} = Vector3.decompose(surface_interaction.normal, ray.direction)

    parallel
    |> Vector3.negate()
    |> Vector3.add(perpendicular)
    |> Vector3.normalize()
  end

  defp filter_for_sample_size(2), do: @k2_filter
  defp filter_for_sample_size(4), do: @k4_filter
  defp filter_for_sample_size(6), do: @k6_filter

  @doc """
  Parses the renderer data from `contents` and returns a new renderer struct.
  """
  @impl Parser
  def parse(contents) do
    with {:ok, camera_data} <- Map.fetch(contents, "camera"),
         {:ok, camera} <- Camera.parse(camera_data),
         {:ok, [ambient_r, ambient_g, ambient_b]} <- Map.fetch(contents, "ambient_light_color"),
         {:ok, attenuation_cutoff} <- Map.fetch(contents, "attenuation_cutoff"),
         {:ok, [bg_r, bg_g, bg_b]} <- Map.fetch(contents, "background_color"),
         {:ok, global_rgb_scale} <- Map.fetch(contents, "global_rgb_scale"),
         {:ok, max_recursive_depth} <- Map.fetch(contents, "max_recursive_depth"),
         {:ok, supersample_size} <- Map.fetch(contents, "supersample_size") do
      {:ok,
       %Renderer{
         camera: camera,
         ambient_light_color: %ColorRGB{red: ambient_r, green: ambient_g, blue: ambient_b},
         attenuation_cutoff: attenuation_cutoff,
         background_color: %ColorRGB{red: bg_r, green: bg_g, blue: bg_b},
         global_rgb_scale: global_rgb_scale,
         max_recursive_depth: max_recursive_depth,
         supersample_size: supersample_size
       }}
    else
      {:error, msg} ->
        {:error, "error parsing renderer: #{msg}"}

      :error ->
        {:error, "error parsing renderer"}
    end
  end
end
