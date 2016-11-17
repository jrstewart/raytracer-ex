defmodule Raytracer.Vector3 do
  alias Raytracer.Point3

  defstruct [
    dx: 0.0,
    dy: 0.0,
    dz: 0.0,
  ]

  def abs(%__MODULE__{dx: dx, dy: dy, dz: dz}) do
    %__MODULE__{dx: Kernel.abs(dx), dy: Kernel.abs(dy), dz: Kernel.abs(dz)}
  end

  def add(%__MODULE__{dx: dx1, dy: dy1, dz: dz1}, %__MODULE__{dx: dx2, dy: dy2, dz: dz2}) do
    %__MODULE__{dx: dx1 + dx2, dy: dy1 + dy2, dz: dz1 + dz2}
  end

  def add(%__MODULE__{dx: dx, dy: dy, dz: dz}, %Point3{x: x, y: y, z: z}) do
    %Point3{x: dx + x, y: dy + y, z: dz + z}
  end

  def cross(%__MODULE__{dx: dx1, dy: dy1, dz: dz1}, %__MODULE__{dx: dx2, dy: dy2, dz: dz2}) do
    %__MODULE__{
      dx: (dy1 * dz2) - (dz1 * dy2),
      dy: (dz1 * dx2) - (dx1 * dz2),
      dz: (dx1 * dy2) - (dy1 * dx2),
    }
  end

  def divide(_vector, scalar) when scalar == 0.0 do
    raise ArgumentError, message: "scalar value 0 results in division by 0"
  end

  def divide(%__MODULE__{dx: dx, dy: dy, dz: dz}, scalar) do
    inverse = 1.0 / scalar
    %__MODULE__{dx: dx * inverse, dy: dy * inverse, dz: dz * inverse}
  end

  def dot(%__MODULE__{dx: dx1, dy: dy1, dz: dz1}, %__MODULE__{dx: dx2, dy: dy2, dz: dz2}) do
    (dx1 * dx2) + (dy1 * dy2) + (dz1 * dz2)
  end

  def length(vector) do
    vector
    |> length_squared
    |> :math.sqrt
  end

  def length_squared(%__MODULE__{dx: dx, dy: dy, dz: dz}) do
    (dx * dx) + (dy * dy) + (dz * dz)
  end

  def multiply(%__MODULE__{dx: dx, dy: dy, dz: dz}, scalar) do
    %__MODULE__{dx: dx * scalar, dy: dy * scalar, dz: dz * scalar}
  end

  def negate(%__MODULE__{dx: dx, dy: dy, dz: dz}) do
    %__MODULE__{dx: -dx, dy: -dy, dz: -dz}
  end

  def normalize(vector) do
    divide(vector, __MODULE__.length(vector))
  end

  def subtract(%__MODULE__{dx: dx1, dy: dy1, dz: dz1}, %__MODULE__{dx: dx2, dy: dy2, dz: dz2}) do
    %__MODULE__{dx: dx1 - dx2, dy: dy1 - dy2, dz: dz1 - dz2}
  end
end
