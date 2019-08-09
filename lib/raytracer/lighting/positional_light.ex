defmodule Raytracer.Lighting.PositionalLight do
  @moduledoc false

  alias __MODULE__
  alias Raytracer.Parser
  alias Raytracer.Geometry.{Point3, Vector3}
  alias Raytracer.Lighting.Light

  defstruct radius: 0.0, position: %Point3{}

  @type t :: %PositionalLight{radius: float(), position: Point3.t()}

  @behaviour Parser

  @doc """
  Parses the light data from `contents` and return a new PositionalLight struct.
  """
  @impl Parser
  def parse(contents) do
    with {:ok, radius} <- Map.fetch(contents, "radius"),
         {:ok, [x, y, z]} <- Map.fetch(contents, "position") do
      {:ok, %PositionalLight{radius: radius, position: %Point3{x: x, y: y, z: z}}}
    else
      :error ->
        {:error, "error parsing positional light"}
    end
  end

  defimpl Light do
    def compute_direction(light, point) do
      light.position |> Point3.subtract(point) |> Vector3.normalize()
    end

    def compute_solid_angle(light, point) do
      distance = Point3.distance_between_squared(light.position, point)
      :math.pi() * light.radius * light.radius / distance
    end
  end
end
