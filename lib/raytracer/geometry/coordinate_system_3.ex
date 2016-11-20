defmodule Raytracer.Geometry.CoordinateSystem3 do
  @moduledoc """
  Three-dimensional coordinate system consisting of u, v, and w axes.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Vector3

  defstruct [
    u_axis: %Vector3{dx: 1.0, dy: 0.0, dz: 0.0},
    v_axis: %Vector3{dx: 0.0, dy: 1.0, dz: 0.0},
    w_axis: %Vector3{dx: 0.0, dy: 0.0, dz: 1.0},
  ]

  @type t :: %CoordinateSystem3{u_axis: Vector3.t, v_axis: Vector3.t, w_axis: Vector3.t}

  @doc """
  Creates a three-dimensional coordinate system from `vector`.

  This function performs a normalization operation on `vector` before creating
  the coordinate system.

  If `vector` is already normalized consider using
  `create_from_normalized_vector/1`.
  """
  @spec create_from_vector(Vector3.t) :: t
  def create_from_vector(vector) do
    vector
    |> Vector3.normalize
    |> create_from_normalized_vector
  end

  @doc """
  Creates a three-dimensional coordinate system from `vector`.

  This function assumes that `vector` is normalized and does not perform a
  normalization operation before creating the coordinate system.

  If `vector` is not normalized consider using `create_from_vector/1`.
  """
  @spec create_from_normalized_vector(Vector3.t) :: t
  def create_from_normalized_vector(
    %Vector3{dx: dx, dy: dy, dz: dz} = vector
  ) when abs(dx) > abs(dy) do
    v_axis =
      %Vector3{dx: -dz, dy: 0.0, dz: dx}
      |> Vector3.divide(:math.sqrt(dx * dx + dz * dz))
    w_axis = Vector3.cross(vector, v_axis)
    %CoordinateSystem3{u_axis: vector, v_axis: v_axis, w_axis: w_axis}
  end

  def create_from_normalized_vector(%Vector3{dy: dy, dz: dz} = vector) do
    v_axis =
      %Vector3{dx: 0.0, dy: dz, dz: -dy}
      |> Vector3.divide(:math.sqrt(dy * dy + dz * dz))
    w_axis = Vector3.cross(vector, v_axis)
    %CoordinateSystem3{u_axis: vector, v_axis: v_axis, w_axis: w_axis}
  end
end
