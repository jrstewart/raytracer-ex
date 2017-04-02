defmodule Raytracer.Geometry.CoordinateSystem do
  @moduledoc """
  Three-dimensional coordinate system consisting of u, v, and w axes.
  """

  alias __MODULE__
  alias Raytracer.Geometry.Vector

  defstruct u_axis: {1.0, 0.0, 0.0},
            v_axis: {0.0, 1.0, 0.0},
            w_axis: {0.0, 0.0, 1.0}

  @type t :: %CoordinateSystem{u_axis: Vector.vector3_t,
                               v_axis: Vector.vector3_t,
                               w_axis: Vector.vector3_t}

  @doc """
  Creates a three-dimensional coordinate system from `vector`.

  This function performs a normalization operation on `vector` before creating
  the coordinate system.

  If `vector` is already normalized consider using
  `create_from_normalized_vector/1`.
  """
  @spec create_from_vector(Vector.vector3_t) :: t
  def create_from_vector(vector) do
    vector
    |> Vector.normalize
    |> create_from_normalized_vector
  end

  @doc """
  Creates a three-dimensional coordinate system from `vector`.

  This function assumes that `vector` is normalized and does not perform a
  normalization operation before creating the coordinate system.

  If `vector` is not normalized consider using `create_from_vector/1`.
  """
  @spec create_from_normalized_vector(Vector.vector3_t) :: t
  def create_from_normalized_vector({dx, dy, dz} = vector) when abs(dx) > abs(dy) do
    v_axis = {-dz, 0.0, dx} |> Vector.divide(:math.sqrt(dx * dx + dz * dz))
    w_axis = Vector.cross(vector, v_axis)
    %CoordinateSystem{u_axis: vector, v_axis: v_axis, w_axis: w_axis}
  end
  def create_from_normalized_vector({_, dy, dz} = vector) do
    v_axis = {0.0, dz, -dy} |> Vector.divide(:math.sqrt(dy * dy + dz * dz))
    w_axis = Vector.cross(vector, v_axis)
    %CoordinateSystem{u_axis: vector, v_axis: v_axis, w_axis: w_axis}
  end
end
