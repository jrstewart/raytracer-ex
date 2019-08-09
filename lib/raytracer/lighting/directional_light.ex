defmodule Raytracer.Lighting.DirectionalLight do
  @moduledoc false

  alias __MODULE__
  alias Raytracer.Parser
  alias Raytracer.Geometry.Vector3
  alias Raytracer.Lighting.Light

  defstruct direction: %Vector3{}, solid_angle: 0.0

  @type t :: %DirectionalLight{direction: Vector3.t(), solid_angle: float()}

  @behaviour Parser

  @doc """
  Parses the light data from `contents` and return a new DirectionalLight struct.
  """
  @impl Parser
  def parse(contents) do
    with {:ok, [dx, dy, dz]} <- Map.fetch(contents, "direction"),
         {:ok, solid_angle} <- Map.fetch(contents, "solid_angle") do
      {:ok,
       %DirectionalLight{direction: %Vector3{dx: dx, dy: dy, dz: dz}, solid_angle: solid_angle}}
    else
      :error ->
        {:error, "error parsing directional light"}
    end
  end

  defimpl Light do
    def compute_direction(light, _point), do: light.direction

    def compute_solid_angle(light, _point), do: light.solid_angle
  end
end
