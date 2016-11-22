defmodule Raytracer.Geometry.Quaternion do
  @moduledoc """
  This module provides a set of functions for working with quaternions
  represented by a {x, y, z, w} tuple.
  """

  alias Raytracer.Geometry

  @type t :: {float, float, float, float}

  @doc """
  Adds two quaternions and returns the resulting quaternion.
  """
  @spec add(t, t) :: t
  def add(quaternion1, quaternion2)
  def add({x1, y1, z1, w1}, {x2, y2, z2, w2}), do: {x1 + x2, y1 + y2, z1 + z2, w1 + w2}

  @doc """
  Divides `quaternion` by `scalar` and returns the resulting quaternion.
  """
  @spec divide(t, float) :: t
  def divide(quaternion, scalar), do: multiply(quaternion, 1.0 / scalar)

  @doc """
  Computes the dot product of `quaternion1` and `quaternion2`.
  """
  @spec dot(t, t) :: float
  def dot(quaternion1, quaternion2)
  def dot({x1, y1, z1, w1}, {x2, y2, z2, w2}), do: (x1 * x2) + (y1 * y2) + (z1 * z2) + (w1 * w2)

  @doc """
  Multiplies `quaternion` by `scalar` and returns the resulting quaternion.
  """
  @spec multiply(t, float) :: t
  def multiply(quaternion, scalar)
  def multiply({x, y, z, w}, scalar), do: {x * scalar, y * scalar, z * scalar, w * scalar}

  @doc """
  Normalizes `quaternion` and returns the resulting quaternion.
  """
  @spec normalize(t) :: t
  def normalize(quaternion) do
    divide(quaternion, quaternion |> dot(quaternion) |> :math.sqrt)
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
  def subtract({x1, y1, z1, w1}, {x2, y2, z2, w2}), do: {x1 - x2, y1 - y2, z1 - z2, w1 - w2}
end
