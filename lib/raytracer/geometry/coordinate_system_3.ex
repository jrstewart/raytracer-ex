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

  @doc """
  Creates a right-handed orthonormal coordinate system from either a single `w` vector or from the
  `v` `w` pair of vectors.

  This function is useful when creating the eye coordinate system axes from typical eye, center, up
  view vectors. For example, eye-center would be used for `w`, and the up vector would be used for
  `v`.

  If `w` is a zero vector, then `u_axis`, `v_axis`, and `w_axis` of the coordinate system are set to
  `(1.0, 0.0, 0.0)`, `(0.0, 1.0, 0.0)`, and `(0.0, 0.0, 1.0)` respectively. Otherwise, `w_axis` is
  set to the normalized value of `w`, and `v_axis` is set to the component of `v` perpendicular to
  `w`. If the resulting `v_axis` is the zero vector (which includes the case where the given `v` is
  the zero vector), then `v_axis` is set to an arbitrary normalized vector perpendicular to `w`.
  Finally, `u_axis` is the cross product of `v_axis` and `w_axis`.
  """
  @spec create_from_vw(Vector3.t(), Vector3.t()) :: t()
  def create_from_vw(_v, %Vector3{dx: 0.0, dy: 0.0, dz: 0.0}) do
    %CoordinateSystem3{
      u_axis: %Vector3{dx: 1.0, dy: 0.0, dz: 0.0},
      v_axis: %Vector3{dx: 0.0, dy: 1.0, dz: 0.0},
      w_axis: %Vector3{dx: 0.0, dy: 0.0, dz: 1.0}
    }
  end

  def create_from_vw(v, w) do
    v = if v == Vector3.zero(), do: compute_arbitrary_normal(w), else: v
    w_axis = Vector3.normalize(w)
    {_, v_perp} = w |> Vector3.normalize() |> Vector3.decompose(v)

    v_axis =
      cond do
        v_perp == Vector3.zero() ->
          compute_arbitrary_normal(w)

        Vector3.perpendicular?(v, w) ->
          v

        true ->
          v_perp
      end
      |> Vector3.normalize()

    u_axis = v_axis |> Vector3.cross(w_axis) |> Vector3.normalize()
    %CoordinateSystem3{u_axis: u_axis, v_axis: v_axis, w_axis: w_axis}
  end

  defp compute_arbitrary_normal(vector) do
    %Vector3{dx: 1.0 / vector.dx, dy: -1.0 / vector.dy, dz: 0.0}
  end
end
