defmodule Raytracer.Vector3 do
  defstruct [
    dx: 0.0,
    dy: 0.0,
    dz: 0.0,
  ]

  @doc """
  Add two vectors or a vector and a point and returns the resulting vector
  or point.
  """
  def add(%__MODULE__{dx: dx1, dy: dy1, dz: dz1}, %__MODULE__{dx: dx2, dy: dy2, dz: dz2}) do
    %__MODULE__{dx: dx1 + dx2, dy: dy1 + dy2, dz: dz1 + dz2}
  end

  @doc """
  Computes the cross product of the given vectors.
  """
  def cross(%__MODULE__{dx: dx1, dy: dy1, dz: dz1}, %__MODULE__{dx: dx2, dy: dy2, dz: dz2}) do
    %__MODULE__{dx: dy1 * dz2 - dz1 * dy2, dy: dz1 * dx2 - dx1 * dz2, dz: dx1 * dy2 - dy1 * dx2}
  end

  @doc """
  Divides a vector by a scalar value and returns the resulting vector.
  """
  def divide(%__MODULE__{dx: dx, dy: dy, dz: dz}, scalar) do
    %__MODULE__{dx: dx / scalar, dy: dy / scalar, dz: dz / scalar}
  end

  @doc """
  Computes the dot product of the given vectors.
  """
  def dot(%__MODULE__{dx: dx1, dy: dy1, dz: dz1}, %__MODULE__{dx: dx2, dy: dy2, dz: dz2}) do
    dx1 * dx2 + dy1 * dy2 + dz1 * dz2
  end

  @doc """
  Computes the length of the given vector.
  """
  def length(%__MODULE__{dx: dx, dy: dy, dz: dz}) do
    :math.sqrt(dx * dx + dy * dy + dz * dz)
  end

  @doc """
  Multiplies a vector by a scalar value and returns the resulting vector.
  """
  def multiply(%__MODULE__{dx: dx, dy: dy, dz: dz}, scalar) do
    %__MODULE__{dx: dx * scalar, dy: dy * scalar, dz: dz * scalar}
  end

  @doc """
  Normalizes the given vector.
  """
  def normalize(vector) do
    divide(vector, __MODULE__.length(vector))
  end

  @doc """
  Subtracts two vectors and returns the resulting vector.
  """
  def subtract(%__MODULE__{dx: dx1, dy: dy1, dz: dz1}, %__MODULE__{dx: dx2, dy: dy2, dz: dz2}) do
    %__MODULE__{dx: dx1 - dx2, dy: dy1 - dy2, dz: dz1 - dz2}
  end
end
