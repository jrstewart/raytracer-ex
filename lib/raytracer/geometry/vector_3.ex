defmodule Raytracer.Geometry.Vector3 do
  alias Raytracer.Geometry.Point3

  defstruct [
    dx: 0.0,
    dy: 0.0,
    dz: 0.0,
  ]

  @type t :: %__MODULE__{dx: float, dy: float, dz: float}

  @spec abs(t) :: t
  def abs(%__MODULE__{dx: dx, dy: dy, dz: dz}) do
    %__MODULE__{dx: Kernel.abs(dx), dy: Kernel.abs(dy), dz: Kernel.abs(dz)}
  end

  @spec add(t, t | Point3.t) :: t | Point3.t
  def add(%__MODULE__{dx: dx1, dy: dy1, dz: dz1}, %__MODULE__{dx: dx2, dy: dy2, dz: dz2}) do
    %__MODULE__{dx: dx1 + dx2, dy: dy1 + dy2, dz: dz1 + dz2}
  end

  def add(%__MODULE__{dx: dx, dy: dy, dz: dz}, %Point3{x: x, y: y, z: z}) do
    %Point3{x: dx + x, y: dy + y, z: dz + z}
  end

  @spec cross(t, t) :: t
  def cross(%__MODULE__{dx: dx1, dy: dy1, dz: dz1}, %__MODULE__{dx: dx2, dy: dy2, dz: dz2}) do
    %__MODULE__{
      dx: (dy1 * dz2) - (dz1 * dy2),
      dy: (dz1 * dx2) - (dx1 * dz2),
      dz: (dx1 * dy2) - (dy1 * dx2),
    }
  end

  @spec divide(t, float) :: t
  def divide(_vector, scalar) when scalar == 0.0 do
    raise ArgumentError, message: "scalar value 0 results in division by 0"
  end

  def divide(vector, scalar) do
    multiply(vector, 1.0 / scalar)
  end

  @spec dot(t, t) :: float
  def dot(%__MODULE__{dx: dx1, dy: dy1, dz: dz1}, %__MODULE__{dx: dx2, dy: dy2, dz: dz2}) do
    (dx1 * dx2) + (dy1 * dy2) + (dz1 * dz2)
  end

  @spec length(t) :: float
  def length(vector) do
    vector |> length_squared |> :math.sqrt
  end

  @spec length_squared(t) :: float
  def length_squared(%__MODULE__{dx: dx, dy: dy, dz: dz}) do
    (dx * dx) + (dy * dy) + (dz * dz)
  end

  @spec max_component(t) :: float
  def max_component(%__MODULE__{dx: dx, dy: dy, dz: dz}) do
    dx |> max(dy) |> max(dz)
  end

  @spec min_component(t) :: float
  def min_component(%__MODULE__{dx: dx, dy: dy, dz: dz}) do
    dx |> min(dy) |> min(dz)
  end

  @spec multiply(t, float) :: t
  def multiply(%__MODULE__{dx: dx, dy: dy, dz: dz}, scalar) do
    %__MODULE__{dx: dx * scalar, dy: dy * scalar, dz: dz * scalar}
  end

  @spec negate(t) :: t
  def negate(%__MODULE__{dx: dx, dy: dy, dz: dz}) do
    %__MODULE__{dx: -dx, dy: -dy, dz: -dz}
  end

  @spec normalize(t) :: t
  def normalize(vector) do
    divide(vector, __MODULE__.length(vector))
  end

  @spec subtract(t, t) :: t
  def subtract(%__MODULE__{dx: dx1, dy: dy1, dz: dz1}, %__MODULE__{dx: dx2, dy: dy2, dz: dz2}) do
    %__MODULE__{dx: dx1 - dx2, dy: dy1 - dy2, dz: dz1 - dz2}
  end
end
