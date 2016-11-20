defmodule Raytracer.Vector2 do
  alias Raytracer.Point2

  defstruct [
    dx: 0.0,
    dy: 0.0,
  ]

  @type t :: %__MODULE__{dx: float, dy: float}

  @spec abs(t) :: t
  def abs(%__MODULE__{dx: dx, dy: dy}) do
    %__MODULE__{dx: Kernel.abs(dx), dy: Kernel.abs(dy)}
  end

  @spec add(t, t | Point2.t) :: t | Point2.t
  def add(%__MODULE__{dx: dx1, dy: dy1}, %__MODULE__{dx: dx2, dy: dy2}) do
    %__MODULE__{dx: dx1 + dx2, dy: dy1 + dy2}
  end

  def add(%__MODULE__{dx: dx, dy: dy}, %Point2{x: x, y: y}) do
    %Point2{x: dx + x, y: dy + y}
  end

  @spec divide(t, float) :: t
  def divide(_vector, scalar) when scalar == 0.0 do
    raise ArgumentError, message: "scalar value 0 results in division by 0"
  end

  def divide(vector, scalar) do
    multiply(vector, 1.0 / scalar)
  end

  @spec dot(t, t) :: float
  def dot(%__MODULE__{dx: dx1, dy: dy1}, %__MODULE__{dx: dx2, dy: dy2}) do
    (dx1 * dx2) + (dy1 * dy2)
  end

  @spec length(t) :: float
  def length(vector) do
    vector |> length_squared |> :math.sqrt
  end

  @spec length_squared(t) :: float
  def length_squared(%__MODULE__{dx: dx, dy: dy}) do
    (dx * dx) + (dy * dy)
  end

  @spec max_component(t) :: float
  def max_component(%__MODULE__{dx: dx, dy: dy}) do
    max(dx, dy)
  end

  @spec min_component(t) :: float
  def min_component(%__MODULE__{dx: dx, dy: dy}) do
    min(dx, dy)
  end

  @spec multiply(t, float) :: t
  def multiply(%__MODULE__{dx: dx, dy: dy}, scalar) do
    %__MODULE__{dx: dx * scalar, dy: dy * scalar}
  end

  @spec negate(t) :: t
  def negate(%__MODULE__{dx: dx, dy: dy}) do
    %__MODULE__{dx: -dx, dy: -dy}
  end

  @spec normalize(t) :: t
  def normalize(vector) do
    divide(vector, __MODULE__.length(vector))
  end

  @spec subtract(t, t) :: t
  def subtract(%__MODULE__{dx: dx1, dy: dy1}, %__MODULE__{dx: dx2, dy: dy2}) do
    %__MODULE__{dx: dx1 - dx2, dy: dy1 - dy2}
  end
end
