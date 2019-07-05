defmodule Raytracer.Geometry.Quaternion do
  @moduledoc """
  This module provides a set of functions for working with quaternions.
  """

  alias __MODULE__
  alias Raytracer.{Geometry, Transform}
  alias Raytracer.Geometry.Matrix4x4

  defstruct x: 0.0, y: 0.0, z: 0.0, w: 0.0

  @type t :: %Quaternion{x: float, y: float, z: float, w: float}

  @doc """
  Adds two quaternions and returns the resulting quaternion.
  """
  @spec add(t, t) :: t
  def add(quaternion1, quaternion2) do
    %Quaternion{
      x: quaternion1.x + quaternion2.x,
      y: quaternion1.y + quaternion2.y,
      z: quaternion1.z + quaternion2.z,
      w: quaternion1.w + quaternion2.w
    }
  end

  @doc """
  Divides `quaternion` by `scalar` and returns the resulting quaternion.
  """
  @spec divide(t, float) :: t
  def divide(quaternion, scalar), do: multiply(quaternion, 1.0 / scalar)

  @doc """
  Computes the dot product of `quaternion1` and `quaternion2`.
  """
  @spec dot(t, t) :: float
  def dot(quaternion1, quaternion2) do
    quaternion1.x * quaternion2.x +
      quaternion1.y * quaternion2.y +
      quaternion1.z * quaternion2.z +
      quaternion1.w * quaternion2.w
  end

  @doc """
  Converts `matrix` into a quaternion.
  """
  @spec from_matrix(Matrix4x4.t()) :: t
  def from_matrix(matrix) do
    trace =
      Matrix4x4.elem(matrix, 0, 0) + Matrix4x4.elem(matrix, 1, 1) + Matrix4x4.elem(matrix, 2, 2)

    if trace > 0.0 do
      compute_from_trace(matrix, trace)
    else
      compute_from_largest_trace_element(matrix)
    end
  end

  defp compute_from_trace(matrix, trace) do
    s = :math.sqrt(trace + 1.0)
    w = s / 2.0
    s = 0.5 / s

    %Quaternion{
      x: (Matrix4x4.elem(matrix, 2, 1) - Matrix4x4.elem(matrix, 1, 2)) * s,
      y: (Matrix4x4.elem(matrix, 0, 2) - Matrix4x4.elem(matrix, 2, 0)) * s,
      z: (Matrix4x4.elem(matrix, 1, 0) - Matrix4x4.elem(matrix, 0, 1)) * s,
      w: w
    }
  end

  defp compute_from_largest_trace_element(matrix) do
    {m00, m01, m02, _, m10, m11, m12, _, m20, m21, m22, _, _, _, _, _} = matrix.elements

    cond do
      m00 > m11 && m00 > m22 ->
        s = :math.sqrt(m00 - (m11 + m22) + 1.0)
        x = s * 0.5
        s = 0.5 / s
        %Quaternion{x: x, y: (m10 + m01) * s, z: (m20 + m02) * s, w: (m21 - m12) * s}

      m11 > m22 ->
        s = :math.sqrt(m11 - (m22 + m00) + 1.0)
        y = s * 0.5
        s = 0.5 / s
        %Quaternion{x: (m01 + m10) * s, y: y, z: (m21 + m12) * s, w: (m02 - m20) * s}

      true ->
        s = :math.sqrt(m22 - (m00 + m11) + 1.0)
        z = s * 0.5
        s = 0.5 / s
        %Quaternion{x: (m02 + m20) * s, y: (m12 + m21) * s, z: z, w: (m10 - m01) * s}
    end
  end

  @doc """
  Converts `transform` into a quaternion.
  """
  @spec from_transform(Transform.t()) :: t
  def from_transform(transform), do: from_matrix(transform.matrix)

  @doc """
  Computes the length of `quaternion`.
  """
  @spec length(t) :: float
  def length(quaternion), do: quaternion |> dot(quaternion) |> :math.sqrt()

  @doc """
  Multiplies `quaternion` by `scalar` and returns the resulting quaternion.
  """
  @spec multiply(t, float) :: t
  def multiply(quaternion, scalar) do
    %Quaternion{
      x: quaternion.x * scalar,
      y: quaternion.y * scalar,
      z: quaternion.z * scalar,
      w: quaternion.w * scalar
    }
  end

  @doc """
  Normalizes `quaternion` and returns the resulting quaternion.
  """
  @spec normalize(t) :: t
  def normalize(quaternion), do: divide(quaternion, Quaternion.length(quaternion))

  @doc """
  Computes the spherical linear interpolation from `quaternion1` to `quaternion2`
  by the value `t`.
  """
  @spec slerp(t, t, float) :: t
  def slerp(quaternion1, quaternion2, t),
    do: do_slerp(quaternion1, quaternion2, t, dot(quaternion1, quaternion2))

  defp do_slerp(quaternion1, quaternion2, t, cos_theta) when cos_theta > 0.9995 do
    quaternion1
    |> multiply(1 - t)
    |> add(multiply(quaternion2, t))
    |> normalize()
  end

  defp do_slerp(quaternion1, quaternion2, t, cos_theta) do
    theta_p = (cos_theta |> Geometry.clamp(-1.0, 1.0) |> :math.acos()) * t
    q_perpendicular = compute_perpendicular(quaternion1, quaternion2, cos_theta)
    add(multiply(quaternion1, :math.cos(theta_p)), multiply(q_perpendicular, :math.sin(theta_p)))
  end

  defp compute_perpendicular(quaternion1, quaternion2, cos_theta) do
    subtract(quaternion2, multiply(quaternion1, cos_theta))
  end

  @doc """
  Subtracts two quaternions and returns the resulting quaternion.
  """
  @spec subtract(t, t) :: t
  def subtract(quaternion1, quaternion2) do
    %Quaternion{
      x: quaternion1.x - quaternion2.x,
      y: quaternion1.y - quaternion2.y,
      z: quaternion1.z - quaternion2.z,
      w: quaternion1.w - quaternion2.w
    }
  end

  @doc """
  Converts `quaternion` to a transform.
  """
  @spec to_transform(t) :: Transform.t()
  def to_transform(quaternion) do
    xx = quaternion.x * quaternion.x
    xy = quaternion.x * quaternion.y
    xz = quaternion.x * quaternion.z
    xw = quaternion.x * quaternion.w
    yy = quaternion.y * quaternion.y
    yz = quaternion.y * quaternion.z
    yw = quaternion.y * quaternion.w
    zz = quaternion.z * quaternion.z
    zw = quaternion.z * quaternion.w

    matrix =
      Matrix4x4.new(
        1 - 2 * (yy + zz),
        2 * (xy + zw),
        2 * (xz - yw),
        0.0,
        2 * (xy - zw),
        1 - 2 * (xx + zz),
        2 * (yz + xw),
        0.0,
        2 * (xz + yw),
        2 * (yz - xw),
        1 - 2 * (xx + yy),
        0.0,
        0.0,
        0.0,
        0.0,
        1.0
      )

    # Transpose for a left-handed coordinate system
    %Transform{matrix: Matrix4x4.transpose(matrix), inverse_matrix: matrix}
  end
end
