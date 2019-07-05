defmodule Raytracer.Geometry.Bounds2 do
  @moduledoc """
  This module provides functions for working with two dimensional axis-aligned bounding boxes.
  """

  alias __MODULE__
  alias Raytracer.Geometry
  alias Raytracer.Geometry.{Point2, Vector2}

  defstruct min: %Point2{}, max: %Point2{}

  @type t :: %Bounds2{min: Point2.t(), max: Point2.t()}

  @doc """
  Return the corner point of `bounds` for the corner index equal to `index`.

  ## Examples

      iex> b = %Bounds2{min: %Point2{x: 0.0, y: 0.0}, max: %Point2{x: 1.0, y: 1.0}}
      iex> Bounds2.corner(b, 0)
      %Point2{x: 0.0, y: 0.0}
      iex> Bounds2.corner(b, 1)
      %Point2{x: 1.0, y: 0.0}
      iex> Bounds2.corner(b, 2)
      %Point2{x: 0.0, y: 1.0}
      iex> Bounds2.corner(b, 3)
      %Point2{x: 1.0, y: 1.0}

  """
  @spec corner(t, 0..3) :: Point2.t()
  def corner(bounds, index)
  def corner(bounds, 0), do: bounds.min
  def corner(bounds, 1), do: %Point2{x: bounds.max.x, y: bounds.min.y}
  def corner(bounds, 2), do: %Point2{x: bounds.min.x, y: bounds.max.y}
  def corner(bounds, 3), do: bounds.max

  @doc """
  Compute the vector along the diagonal of `bounds` from the minimum point to the maximum point.

  ## Examples

      iex> b = %Bounds2{min: %Point2{x: -1.0, y: -1.0}, max: %Point2{x: 1.0, y: 1.0}}
      iex> Bounds2.diagonal(b)
      %Vector2{dx: 2.0, dy: 2.0}

  """
  @spec diagonal(t) :: Vector2.t()
  def diagonal(bounds), do: Point2.subtract(bounds.max, bounds.min)

  @doc """
  Pads `bounds` in all directions by the value of `delta`.
  """
  @spec expand(t, float) :: t
  def expand(bounds, delta) do
    v = %Vector2{dx: delta, dy: delta}
    %Bounds2{min: Point2.subtract(bounds.min, v), max: Point2.add(bounds.max, v)}
  end

  @doc """
  Checks if `point` is inside `bounds`.
  """
  @spec inside?(t, Point2.t()) :: boolean
  def inside?(bounds, point) do
    point.x >= bounds.min.x && point.x <= bounds.max.x &&
      point.y >= bounds.min.y && point.y <= bounds.max.y
  end

  @doc """
  Checks if `point` is inside `bounds` excluding the upper boundary of `bounds`.
  """
  @spec inside_exclusive?(t, Point2.t()) :: boolean
  def inside_exclusive?(bounds, point) do
    point.x >= bounds.min.x && point.x < bounds.max.x &&
      point.y >= bounds.min.y && point.y < bounds.max.y
  end

  @doc """
  Compute the bounding box that is the intersection of `bounds1` and `bounds2`.
  """
  @spec intersect(t, t) :: t
  def intersect(bounds1, bounds2) do
    %Bounds2{
      min: %Point2{x: max(bounds1.min.x, bounds2.min.x), y: max(bounds1.min.y, bounds2.min.y)},
      max: %Point2{x: min(bounds1.max.x, bounds2.max.x), y: min(bounds1.max.y, bounds2.max.y)}
    }
  end

  @doc """
  Linearly interpolates the point between the minimum and maximum corners of `bounds` by the given
  amount in each direction specified by `tx` and `ty` values.
  """
  @spec lerp(t, float, float) :: Point2.t()
  def lerp(bounds, tx, ty) do
    %Point2{
      x: Geometry.lerp(bounds.min.x, bounds.max.x, tx),
      y: Geometry.lerp(bounds.min.y, bounds.max.y, ty)
    }
  end

  @doc """
  Returns either `:x` or `:y` indicating the direction of the largest extent of `bounds`.
  """
  @spec maximum_extent(t) :: :x | :y
  def maximum_extent(bounds), do: bounds |> diagonal() |> find_largest_extent()

  defp find_largest_extent(%Vector2{dx: dx, dy: dy}) when dx > dy, do: :x
  defp find_largest_extent(_), do: :y

  @doc """
  Creates a new bounding box from the given `min` and `max` points returning `{:ok, bounds}` where
  `bounds` is the created bounding box.

  `{:error, message}` is returned if the given points do not create a valid bounding box.

  ## Examples

      iex> min = %Point2{x: -1.0, y: -1.0}
      iex> max = %Point2{x: 2.0, y: 2.0}
      iex> Bounds2.new(min, max)
      {:ok, %Bounds2{min: %Point2{x: -1.0, y: -1.0}, max: %Point2{x: 2.0, y: 2.0}}}
      iex> Bounds2.new(max, min)
      {:error, "Invalid min and max points for bounds"}

  """
  @spec new(Point2.t(), Point2.t()) :: {:ok, t} | {:error, String.t()}
  def new(%Point2{x: min_x, y: min_y} = min, %Point2{x: max_x, y: max_y} = max)
      when min_x <= max_x and min_y <= max_y do
    {:ok, %Bounds2{min: min, max: max}}
  end

  def new(_min, _max), do: {:error, "Invalid min and max points for bounds"}

  @doc """
  Creates a new bounding box from the given `min_x`, `min_y`, `max_x`, and `max_y` values
  returning `{:ok, bounds}` where `bounds` is the created bounding box.

  `{:error, message}` is returned if the given values do not create a valid bounding box.

  ## Examples

      iex> Bounds2.new(-1.0, -1.0, 2.0, 2.0)
      {:ok, %Bounds2{min: %Point2{x: -1.0, y: -1.0}, max: %Point2{x: 2.0, y: 2.0}}}
      iex> Bounds2.new(-1.0, 2.0, 1.0, -2.0)
      {:error, "Invalid min and max values for bounds"}

  """
  @spec new(float, float, float, float) :: {:ok, t} | {:error, String.t()}
  def new(min_x, min_y, max_x, max_y) when min_x <= max_x and min_y <= max_y do
    {:ok, %Bounds2{min: %Point2{x: min_x, y: min_y}, max: %Point2{x: max_x, y: max_y}}}
  end

  def new(_min_x, _min_y, _max_x, _max_y), do: {:error, "Invalid min and max values for bounds"}

  @doc """
  Returns the continuous position of `point` relative to the minimum and maximum corners of
  `bounds`. A point at the minimum corner has an offset of (0, 0) and a point at the maximum corner
  has an offset of (1, 1).
  """
  @spec offset(t, Point2.t()) :: {float, float}
  def offset(bounds, point), do: {offset_x(bounds, point), offset_y(bounds, point)}

  defp offset_x(bounds, point) do
    if bounds.max.x > bounds.min.x do
      (point.x - bounds.min.x) / (bounds.max.x - bounds.min.x)
    else
      point.x - bounds.min.x
    end
  end

  defp offset_y(bounds, point) do
    if bounds.max.y > bounds.min.y do
      (point.y - bounds.min.y) / (bounds.max.y - bounds.min.y)
    else
      point.y - bounds.min.y
    end
  end

  @doc """
  Checks if `bounds1` and `bounds2` overlap.
  """
  @spec overlap?(t, t) :: boolean
  def overlap?(bounds1, bounds2) do
    bounds1.max.x >= bounds2.min.x && bounds1.min.x <= bounds2.max.x &&
      bounds1.max.y >= bounds2.min.y && bounds1.min.y <= bounds2.max.y
  end

  @doc """
  Given a bounding box and a point, this function computes a new bounding box that encompasses both
  the bounding box and point. Given two bounding boxes, this function computes a new bounding box
  that bounds the space encompassed by the two bounding boxes.
  """
  @spec union(t, t | Point2.t()) :: t
  def union(bounds, bounds_or_point)

  def union(bounds1, %Bounds2{} = bounds2) do
    %Bounds2{
      min: %Point2{x: min(bounds1.min.x, bounds2.min.x), y: min(bounds1.min.y, bounds2.min.y)},
      max: %Point2{x: max(bounds1.max.x, bounds2.max.x), y: max(bounds1.max.y, bounds2.max.y)}
    }
  end

  def union(bounds, %Point2{} = point) do
    %Bounds2{
      min: %Point2{x: min(bounds.min.x, point.x), y: min(bounds.min.y, point.y)},
      max: %Point2{x: max(bounds.max.x, point.x), y: max(bounds.max.y, point.y)}
    }
  end
end
