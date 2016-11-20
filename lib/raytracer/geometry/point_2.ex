defmodule Raytracer.Geometry.Point2 do
  alias Raytracer.Geometry.Vector2

  defstruct [
    x: 0.0,
    y: 0.0,
  ]

  @type t :: %__MODULE__{x: float, y: float}

  @spec abs(t) :: t
  def abs(%__MODULE__{x: x, y: y}) do
    %__MODULE__{x: Kernel.abs(x), y: Kernel.abs(y)}
  end

  @spec add(t, t | Vector2.t) :: t
  def add(%__MODULE__{x: x1, y: y1}, %__MODULE__{x: x2, y: y2}) do
    %__MODULE__{x: x1 + x2, y: y1 + y2}
  end

  def add(%__MODULE__{x: x, y: y}, %Vector2{dx: dx, dy: dy}) do
    %__MODULE__{x: x + dx, y: y + dy}
  end

  @spec distance_between(t, t) :: float
  def distance_between(point1, point2) do
    point1 |> subtract(point2) |> Vector2.length
  end

  @spec distance_between_squared(t, t) :: float
  def distance_between_squared(point1, point2) do
    point1 |> subtract(point2) |> Vector2.length_squared
  end

  @spec divide(t, float) :: t
  def divide(_point, scalar) when scalar == 0.0 do
    raise ArgumentError, message: "scalar value 0 results in division by 0"
  end

  def divide(point, scalar) do
    multiply(point, 1.0 / scalar)
  end

  @spec lerp(float, t, t) :: t
  def lerp(t, point1, point2) do
    point1
    |> multiply(1 - t)
    |> add(multiply(point2, t))
  end

  @spec multiply(t, float) :: t
  def multiply(%__MODULE__{x: x, y: y}, scalar) do
    %__MODULE__{x: x * scalar, y: y * scalar}
  end

  @spec subtract(t, t | Vector2.t) :: t | Vector2.t
  def subtract(%__MODULE__{x: x, y: y}, %Vector2{dx: dx, dy: dy}) do
    %__MODULE__{x: x - dx, y: y - dy}
  end

  def subtract(%__MODULE__{x: x1, y: y1}, %__MODULE__{x: x2, y: y2}) do
    %Vector2{dx: x1 - x2, dy: y1 - y2}
  end
end
