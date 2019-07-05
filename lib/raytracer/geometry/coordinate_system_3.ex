defmodule Raytracer.Geometry.CoordinateSystem3 do
  @moduledoc """
  Three-dimensional coordinate system consisting of u, v, and w axes.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Vector3

  defstruct u_axis: %Vector3{dx: 1.0, dy: 0.0, dz: 0.0},
            v_axis: %Vector3{dx: 0.0, dy: 1.0, dz: 0.0},
            w_axis: %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}

  @type t :: %CoordinateSystem3{u_axis: Vector3.t(), v_axis: Vector3.t(), w_axis: Vector3.t()}

  @doc """
  Creates a three-dimensional coordinate system from `vector`.

  This function performs a normalization operation on `vector` before creating the coordinate
  system.

  If `vector` is already normalized consider using `create_from_normalized_vector/1`.
  """
  @spec create_from_vector(Vector3.t()) :: t
  def create_from_vector(vector),
    do: vector |> Vector3.normalize() |> create_from_normalized_vector()

  @doc """
  Creates a three-dimensional coordinate system from `vector`.

  This function assumes that `vector` is normalized and does not perform a normalization operation
  before creating the coordinate system.

  If `vector` is not normalized consider using `create_from_vector/1`.
  """
  @spec create_from_normalized_vector(Vector3.t()) :: t
  def create_from_normalized_vector(%Vector3{dx: dx, dy: dy} = vector) when abs(dx) > abs(dy) do
    v_axis =
      %Vector3{dx: -vector.dz, dy: 0.0, dz: vector.dx}
      |> Vector3.divide(:math.sqrt(vector.dx * vector.dx + vector.dz * vector.dz))

    %CoordinateSystem3{u_axis: vector, v_axis: v_axis, w_axis: Vector3.cross(vector, v_axis)}
  end

  def create_from_normalized_vector(vector) do
    v_axis =
      %Vector3{dx: 0.0, dy: vector.dz, dz: -vector.dy}
      |> Vector3.divide(:math.sqrt(vector.dy * vector.dy + vector.dz * vector.dz))

    %CoordinateSystem3{u_axis: vector, v_axis: v_axis, w_axis: Vector3.cross(vector, v_axis)}
  end
end
