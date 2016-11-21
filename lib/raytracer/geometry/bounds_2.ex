defmodule Raytracer.Geometry.Bounds2 do
  @moduledoc """
  Axis-aligned two-dimensional bounding box.
  """

  alias __MODULE__
  alias Raytracer.Geometry
  alias Raytracer.Geometry.{Point2, Vector2}

  defstruct [
    min_point: %Point2{},
    max_point: %Point2{},
  ]

  @type t :: %Bounds2{min_point: Point2.t, max_point: Point2.t}

  @doc """
  Return the corner point at `corner_index` of `bounds`.
  """
  @spec corner(t, 0..3) :: Point2.t
  def corner(bounds, corner_index)

  def corner(%Bounds2{min_point: min_point}, 0) do
    min_point
  end

  def corner(%Bounds2{min_point: %Point2{y: y}, max_point: %Point2{x: x}}, 1) do
    %Point2{x: x, y: y}
  end

  def corner(%Bounds2{min_point: %Point2{x: x}, max_point: %Point2{y: y}}, 2) do
    %Point2{x: x, y: y}
  end

  def corner(%Bounds2{max_point: max_point}, 3) do
    max_point
  end

  @doc """
  Compute the vector along the diagonal of `bounds` from the minimum point to the
  maximum point.
  """
  @spec diagonal(t) :: Vector2.t
  def diagonal(bounds)

  def diagonal(%Bounds2{min_point: min_point, max_point: max_point}) do
    Point2.subtract(max_point, min_point)
  end

  @doc """
  Pads `bounds` in all directions by the value of `delta`.
  """
  @spec expand(t, number) :: t
  def expand(bounds, delta)

  def expand(%Bounds2{min_point: min_point, max_point: max_point}, delta) do
    v = %Vector2{dx: delta, dy: delta}
    %Bounds2{
      min_point: min_point |> Point2.subtract(v),
      max_point: max_point |> Point2.add(v),
    }
  end

  @doc """
  Checks if `point` is inside `bounds`.
  """
  @spec inside?(t, Point2.t) :: boolean
  def inside?(bounds, point)

  def inside?(
    %Bounds2{min_point: %Point2{x: min_x, y: min_y}, max_point: %Point2{x: max_x, y: max_y}},
    %Point2{x: x, y: y}
  ) do
    x >= min_x && x <= max_x && y >= min_y && y <= max_y
  end

  @doc """
  Checks if `point` is inside `bounds` excluding the upper boundary of `bounds`.
  """
  @spec inside_exclusive?(t, Point2.t) :: boolean
  def inside_exclusive?(bounds, point)

  def inside_exclusive?(
    %Bounds2{min_point: %Point2{x: min_x, y: min_y}, max_point: %Point2{x: max_x, y: max_y}},
    %Point2{x: x, y: y}
  ) do
    x >= min_x && x < max_x && y >= min_y && y < max_y
  end

  @doc """
  Compute the bounding box that is the intersection of `bounds1` and `bounds2`.
  """
  @spec intersect(t, t) :: t
  def intersect(bounds1, bounds2)

  def intersect(
    %Bounds2{min_point: %Point2{x: min_x1, y: min_y1}, max_point: %Point2{x: max_x1, y: max_y1}},
    %Bounds2{min_point: %Point2{x: min_x2, y: min_y2}, max_point: %Point2{x: max_x2, y: max_y2}}
  ) do
    %Bounds2{
      min_point: %Point2{x: max(min_x1, min_x2), y: max(min_y1, min_y2)},
      max_point: %Point2{x: min(max_x1, max_x2), y: min(max_y1, max_y2)},
    }
  end

  @doc """
  Linearly interpolates the point between the minimum and maximum corners of
  `bounds` by the given amount in each direction specified by the x and y
  values of the map `values`.
  """
  @spec lerp(t, %{tx: number, ty: number}) :: Point2.t
  def lerp(bounds, values)

  def lerp(
    %Bounds2{min_point: %Point2{x: min_x, y: min_y}, max_point: %Point2{x: max_x, y: max_y}},
    %{tx: tx, ty: ty}
  ) do
    %Point2{x: Geometry.lerp(min_x, max_x, tx), y: Geometry.lerp(min_y, max_y, ty)}
  end

  @doc """
  Returns either `:x` or `:y` indicating the direction of the largest extent
  of `bounds`.
  """
  @spec maximum_extent(t) :: atom
  def maximum_extent(bounds) do
    bounds
    |> diagonal
    |> find_largest_extent
  end

  defp find_largest_extent(%Vector2{dx: dx, dy: dy}) when dx > dy, do: :x
  defp find_largest_extent(_vector), do: :y

  @doc """
  Returns the continuous position of `point` relative to the minimum and maximum
  corners of `bounds`. A point at the minimum corner has an offset of (0, 0) and
  a point at the maximum corner has an offset of (1, 1).
  """
  @spec offset(t, Point2.t) :: %{x: number, y: number}
  def offset(bounds, point) do
    %{x: offset_x(bounds, point), y: offset_y(bounds, point)}
  end

  defp offset_x(
    %Bounds2{min_point: %Point2{x: min_x}, max_point: %Point2{x: max_x}},
    %Point2{x: x}
  ) when max_x > min_x do
    (x - min_x) / (max_x - min_x)
  end

  defp offset_x(%Bounds2{min_point: %Point2{x: min_x}}, %Point2{x: x}) do
    x - min_x
  end

  defp offset_y(
    %Bounds2{min_point: %Point2{y: min_y}, max_point: %Point2{y: max_y}},
    %Point2{y: y}
  ) when max_y > min_y do
    (y - min_y) / (max_y - min_y)
  end

  defp offset_y(%Bounds2{min_point: %Point2{y: min_y}}, %Point2{y: y}) do
    y - min_y
  end

  @doc """
  Checks if `bounds1` and `bounds` overlap.
  """
  @spec overlap?(t, t) :: boolean
  def overlap?(bounds1, bounds2)

  def overlap?(
    %Bounds2{min_point: %Point2{x: min_x1, y: min_y1}, max_point: %Point2{x: max_x1, y: max_y1}},
    %Bounds2{min_point: %Point2{x: min_x2, y: min_y2}, max_point: %Point2{x: max_x2, y: max_y2}}
  ) do
    max_x1 >= min_x2 && min_x1 <= max_x2 && max_y1 >= min_y2 && min_y1 <= max_y2
  end

  @doc """
  Given a bounding box and a point, this function computes a new bounding box
  that encompasses both the bounding box and point. Given two bounding boxes,
  this function computes a new bounding box that bounds the space encompassed by
  the two bounding boxes.
  """
  @spec union(t, t | Point2.t) :: t
  def union(bounds, bounds_or_point)

  def union(
    %Bounds2{min_point: %Point2{x: min_x1, y: min_y1}, max_point: %Point2{x: max_x1, y: max_y1}},
    %Bounds2{min_point: %Point2{x: min_x2, y: min_y2}, max_point: %Point2{x: max_x2, y: max_y2}}
  ) do
    %Bounds2{
      min_point: %Point2{x: min(min_x1, min_x2), y: min(min_y1, min_y2)},
      max_point: %Point2{x: max(max_x1, max_x2), y: max(max_y1, max_y2)},
    }
  end

  def union(
    %Bounds2{min_point: %Point2{x: min_x, y: min_y}, max_point: %Point2{x: max_x, y: max_y}},
    %Point2{x: x, y: y}
  ) do
    %Bounds2{
      min_point: %Point2{x: min(min_x, x), y: min(min_y, y)},
      max_point: %Point2{x: max(max_x, x), y: max(max_y, y)},
    }
  end
end
