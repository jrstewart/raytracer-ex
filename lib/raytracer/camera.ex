defmodule Raytracer.Camera do
  @moduledoc false

  alias __MODULE__
  alias Raytracer.Geometry.{Point3, Vector3}

  @enforce_keys [:center, :distance, :eye, :height, :width, :up, :world_coordinates_window]
  defstruct [:center, :distance, :eye, :height, :width, :up, :world_coordinates_window]

  @type t :: %Camera{
          center: Point3.t(),
          distance: float,
          eye: Point3.t(),
          height: integer(),
          width: integer(),
          world_coordinates_window: {float(), float(), float(), float()},
          up: Vector3.t()
        }

  @doc """
  Returns a list of points that represent the pixel grid of `camera`. The points represent the
  center point of each of the pixels of the grid.
  """
  @spec pixel_grid(Camera.t()) :: list(Point3.t())
  def pixel_grid(camera) do
    center_to_eye =
      camera.eye
      |> Point3.subtract(camera.center)
      |> Vector3.normalize()

    grid_horizontal_direction =
      camera.up
      |> Vector3.cross(center_to_eye)
      |> Vector3.normalize()

    pixel_grid_center =
      camera.eye
      |> Point3.subtract(Vector3.multiply(center_to_eye, camera.distance))

    {u_min, _, v_min, _} = camera.world_coordinates_window

    grid_lower_left =
      pixel_grid_center
      |> Point3.add(Vector3.multiply(grid_horizontal_direction, u_min))
      |> Point3.add(Vector3.multiply(camera.up, v_min))

    {pixel_width, pixel_height} = pixel_size(camera)
    h_offset = pixel_width / 2.0
    v_offset = pixel_height / 2.0

    for row <- 0..(camera.height - 1), column <- 0..(camera.width - 1) do
      h = Vector3.multiply(grid_horizontal_direction, column * pixel_width + h_offset)
      v = Vector3.multiply(camera.up, row * pixel_height + v_offset)

      grid_lower_left
      |> Point3.add(h)
      |> Point3.add(v)
    end
  end

  @doc """
  Returns a two element tuple containing the pixel width and height of `camera`.
  """
  @spec pixel_size(Camera.t()) :: {float(), float()}
  def pixel_size(camera) do
    {u_min, u_max, v_min, v_max} = camera.world_coordinates_window
    width = (u_max - u_min) / camera.width
    height = (v_max - v_min) / camera.height
    {width, height}
  end
end
