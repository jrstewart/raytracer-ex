defmodule Raytracer.Geometry.Quaternion do
  @moduledoc """
  This module provides a set of functions for working with quaternions
  represented by a {x, y, z, w} tuple.
  """

  alias __MODULE__
  alias Raytracer.Geometry
  alias Raytracer.Geometry.Matrix
  alias Raytracer.Transform

  @type t :: {float, float, float, float}

  @doc """
  Adds two quaternions and returns the resulting quaternion.
  """
  @spec add(t, t) :: t
  def add(quaternion1, quaternion2)
  def add({x1, y1, z1, w1}, {x2, y2, z2, w2}) do
    {x1 + x2, y1 + y2, z1 + z2, w1 + w2}
  end

  @doc """
  Divides `quaternion` by `scalar` and returns the resulting quaternion.
  """
  @spec divide(t, float) :: t
  def divide(quaternion, scalar) do
    multiply(quaternion, 1.0 / scalar)
  end

  @doc """
  Computes the dot product of `quaternion1` and `quaternion2`.
  """
  @spec dot(t, t) :: float
  def dot(quaternion1, quaternion2)
  def dot({x1, y1, z1, w1}, {x2, y2, z2, w2}) do
    (x1 * x2) + (y1 * y2) + (z1 * z2) + (w1 * w2)
  end

  @doc """
  Converts `transform` into a quaternion.
  """
  @spec from_transform(Transform.t) :: t
  def from_transform(transform)
  def from_transform(%Transform{matrix: {m00,   _,   _, _,
                                           _, m11,   _, _,
                                           _,   _, m22, _,
                                           _,   _,   _, _}} = transform) do
    trace = m00 + m11 + m22
    if trace > 0.0 do
      compute_from_trace(transform.matrix, trace)
    else
      compute_from_largest_trace_element(transform.matrix)
    end
  end

  defp compute_from_trace({  _, m01, m02, _,
                           m10,   _, m12, _,
                           m20, m21,   _, _,
                             _,   _,   _, _}, trace) do
    s = :math.sqrt(trace + 1.0)
    w = s / 2.0
    s = 0.5 / s
    {(m21 - m12) * s, (m02 - m20) * s, (m10 - m01) * s, w}
  end

  defp compute_from_largest_trace_element({m00, m01, m02, _,
                                           m10, m11, m12, _,
                                           m20, m21, m22, _,
                                             _,   _,   _, _}) when m00 > m11 and m00 > m22 do
    s = :math.sqrt((m00 - (m11 + m22)) + 1.0)
    x = s * 0.5
    s = 0.5 / s
    {x, (m10 + m01) * s, (m20 + m02) * s, (m21 - m12) * s}
  end
  defp compute_from_largest_trace_element({m00, m01, m02, _,
                                           m10, m11, m12, _,
                                           m20, m21, m22, _,
                                             _,   _,   _, _}) when m11 > m22 do
    s = :math.sqrt((m11 - (m22 + m00)) + 1.0)
    y = s * 0.5
    s = 0.5 / s
    {(m01 + m10) * s, y, (m21 + m12) * s, (m02 - m20) * s}
  end
  defp compute_from_largest_trace_element({m00, m01, m02, _,
                                           m10, m11, m12, _,
                                           m20, m21, m22, _,
                                             _,   _,   _, _}) do
    s = :math.sqrt((m22 - (m00 + m11)) + 1.0)
    z = s * 0.5
    s = 0.5 / s
    {(m02 + m20) * s, (m12 + m21) * s, z, (m10 - m01) * s}
  end

  @doc """
  Computes the length of `quaterion`.
  """
  @spec length(t) :: float
  def length(quaternion) do
    quaternion |> dot(quaternion) |> :math.sqrt
  end

  @doc """
  Multiplies `quaternion` by `scalar` and returns the resulting quaternion.
  """
  @spec multiply(t, float) :: t
  def multiply(quaternion, scalar)
  def multiply({x, y, z, w}, scalar) do
    {x * scalar, y * scalar, z * scalar, w * scalar}
  end

  @doc """
  Normalizes `quaternion` and returns the resulting quaternion.
  """
  @spec normalize(t) :: t
  def normalize(quaternion) do
    divide(quaternion, Quaternion.length(quaternion))
  end

  @doc """
  Computes the spherical linear interpolation from `quaternion1` to `quaterionn2`
  by the value `t`.
  """
  @spec slerp(t, t, float) :: t
  def slerp(quaternion1, quaternion2, t) do
    do_slerp(quaternion1, quaternion2, t, dot(quaternion1, quaternion2))
  end

  defp do_slerp(quaternion1, quaternion2, t, cos_theta) when cos_theta > 0.9995 do
    quaternion1
    |> multiply(1 - t)
    |> add(multiply(quaternion2, t))
    |> normalize
  end
  defp do_slerp(quaternion1, quaternion2, t, cos_theta) do
    theta = cos_theta |> Geometry.clamp(-1.0, 1.0) |> :math.acos
    theta_p = theta * t
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
  def subtract(quaternion1, quaternion2)
  def subtract({x1, y1, z1, w1}, {x2, y2, z2, w2}) do
    {x1 - x2, y1 - y2, z1 - z2, w1 - w2}
  end

  @doc """
  Converts `quaternion` to a transform.
  """
  @spec to_transform(t) :: Transform.t
  def to_transform(quaternion)
  def to_transform({x, y, z, w}) do
    xx = x * x
    xy = x * y
    xz = x * z
    xw = x * w
    yy = y * y
    yz = y * z
    yw = y * w
    zz = z * z
    zw = z * w

    m = {1 - 2 * (yy + zz),     2 * (xy + zw),     2 * (xz - yw), 0.0,
             2 * (xy - zw), 1 - 2 * (xx + zz),     2 * (yz + xw), 0.0,
             2 * (xz + yw),     2 * (yz - xw), 1 - 2 * (xx + yy), 0.0,
                       0.0,               0.0,               0.0, 1.0}

    # Transpose for a left-handed coordinate system
    %Transform{matrix: Matrix.transpose(m), inverse_matrix: m}
  end
end
