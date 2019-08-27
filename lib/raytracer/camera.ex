defmodule Raytracer.Camera do
  @moduledoc false

  alias __MODULE__
  alias Raytracer.Parser
  alias Raytracer.Geometry.{CoordinateSystem3, Point3, Vector3}

  @enforce_keys [:coords, :distance, :eye, :height, :width, :wc_window]
  defstruct [:coords, :distance, :eye, :height, :width, :wc_window]

  @type t :: %Camera{
          coords: CoordinateSystem3.t(),
          distance: float,
          eye: Point3.t(),
          height: integer(),
          width: integer(),
          wc_window: %{u_min: float(), u_max: float(), v_min: float(), v_max: float()}
        }

  @behaviour Parser

  @doc """
  Parses the camera data from `contents` and returns a new Camera struct.
  """
  @impl Parser
  def parse(contents) do
    with {:ok, [center_x, center_y, center_z]} <- Map.fetch(contents, "center"),
         {:ok, distance} <- Map.fetch(contents, "distance"),
         {:ok, [eye_x, eye_y, eye_z]} <- Map.fetch(contents, "eye"),
         {:ok, height} <- Map.fetch(contents, "height"),
         {:ok, width} <- Map.fetch(contents, "width"),
         {:ok, [u_min, u_max, v_min, v_max]} <- Map.fetch(contents, "wc_window"),
         {:ok, [up_dx, up_dy, up_dz]} <- Map.fetch(contents, "up") do
      center = %Point3{x: center_x, y: center_y, z: center_z}
      eye = %Point3{x: eye_x, y: eye_y, z: eye_z}
      up = %Vector3{dx: up_dx, dy: up_dy, dz: up_dz} |> Vector3.normalize()
      center_to_eye = Point3.subtract(eye, center)

      {:ok,
       %Camera{
         coords: CoordinateSystem3.create_from_vw(up, center_to_eye),
         distance: distance,
         eye: eye,
         height: height,
         width: width,
         wc_window: %{u_min: u_min, u_max: u_max, v_min: v_min, v_max: v_max}
       }}
    else
      :error ->
        {:error, "error parsing camera"}
    end
  end

  @doc """
  Returns a list of points that represent the pixel grid of `camera`. The points represent the
  center point of each of the pixels of the grid.
  """
  @spec pixel_grid(Camera.t()) :: list(Point3.t())
  def pixel_grid(camera) do
    pixel_grid_center =
      Point3.subtract(camera.eye, Vector3.multiply(camera.coords.w_axis, camera.distance))

    grid_lower_left =
      pixel_grid_center
      |> Point3.add(Vector3.multiply(camera.coords.u_axis, camera.wc_window.u_min))
      |> Point3.add(Vector3.multiply(camera.coords.v_axis, camera.wc_window.v_min))

    {pixel_width, pixel_height} = pixel_size(camera)

    for row <- 0..(camera.height - 1), column <- 0..(camera.width - 1) do
      h = Vector3.multiply(camera.coords.u_axis, column * pixel_width)
      v = Vector3.multiply(camera.coords.v_axis, row * pixel_height)

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
    width = (camera.wc_window.u_max - camera.wc_window.u_min) / camera.width
    height = (camera.wc_window.v_max - camera.wc_window.v_min) / camera.height
    {width, height}
  end
end
