defmodule Raytracer.Geometry.Bounds do
  @moduledoc """
  This module provides functions for working with two and three dimensional
  axis-aligned bounding box.
  """

  alias __MODULE__
  alias Raytracer.Geometry
  alias Raytracer.Geometry.Point
  alias Raytracer.Geometry.Vector
  alias Raytracer.Transform

  defstruct min_point: {0.0, 0.0, 0.0},
            max_point: {0.0, 0.0, 0.0}

  @type t :: %Bounds{min_point: Point.t, max_point: Point.t}

  @doc """
  Applies `transform` to `bounds` and returns the resulting bounding box.
  """
  @spec apply_transform(t, Transform.t) :: t
  def apply_transform(%Bounds{min_point: {min_x, min_y, min_z},
                              max_point: {max_x, max_y, max_z}} = bounds, transform) do
    bounds
    |> union(Point.apply_transform({min_x, min_y, min_z}, transform))
    |> union(Point.apply_transform({max_x, min_y, min_z}, transform))
    |> union(Point.apply_transform({min_x, max_y, min_z}, transform))
    |> union(Point.apply_transform({min_x, min_y, max_z}, transform))
    |> union(Point.apply_transform({max_x, max_y, min_z}, transform))
    |> union(Point.apply_transform({max_x, min_y, max_z}, transform))
    |> union(Point.apply_transform({max_x, max_y, max_z}, transform))
  end

  @doc """
  Return the corner point of `bounds` with index equal to `index`.
  """
  @spec corner(t, 0..7) :: Point.t
  def corner(bounds, index)
  def corner(%Bounds{min_point: min_point}, 0) do
    min_point
  end
  def corner(%Bounds{min_point: {_, y_min}, max_point: {x_max, _}}, 1) do
    {x_max, y_min}
  end
  def corner(%Bounds{min_point: {x_min, _}, max_point: {_, y_max}}, 2) do
    {x_min, y_max}
  end
  def corner(%Bounds{min_point: {_, _}, max_point: {x_max, y_max}}, 3) do
    {x_max, y_max}
  end
  def corner(%Bounds{min_point: {_, y_min, z_min}, max_point: {x_max, _, _}}, 1) do
    {x_max, y_min, z_min}
  end
  def corner(%Bounds{min_point: {x_min, _, z_min}, max_point: {_, y_max, _}}, 2) do
    {x_min, y_max, z_min}
  end
  def corner(%Bounds{min_point: {_, _, z_min}, max_point: {x_max, y_max, _}}, 3) do
    {x_max, y_max, z_min}
  end
  def corner(%Bounds{min_point: {x_min, y_min, _}, max_point: {_, _, z_max}}, 4) do
    {x_min, y_min, z_max}
  end
  def corner(%Bounds{min_point: {_, y_min, _}, max_point: {x_max, _, z_max}}, 5) do
    {x_max, y_min, z_max}
  end
  def corner(%Bounds{min_point: {x_min, _, _}, max_point: {_, y_max, z_max}}, 6) do
    {x_min, y_max, z_max}
  end
  def corner(%Bounds{max_point: {x, y, z}}, 7) do
    {x, y, z}
  end

  @doc """
  Compute the vector along the diagonal of `bounds` from the minimum point to
  the maximum point.
  """
  @spec diagonal(t) :: Vector.t
  def diagonal(bounds)
  def diagonal(%Bounds{min_point: min_point, max_point: max_point}) do
    Point.subtract(max_point, min_point)
  end

  @doc """
  Pads `bounds` in all directions by the value of `delta`.
  """
  @spec expand(t, number) :: t
  def expand(%Bounds{min_point: {_, _}, max_point: {_, _}} = bounds, delta) do
    v = {delta, delta}
    %Bounds{min_point: Point.subtract(bounds.min_point, v),
            max_point: Point.add(bounds.max_point, v)}
  end
  def expand(%Bounds{min_point: {_, _, _}, max_point: {_, _, _}} = bounds, delta) do
    v = {delta, delta, delta}
    %Bounds{min_point: Point.subtract(bounds.min_point, v),
            max_point: Point.add(bounds.max_point, v)}
  end

  @doc """
  Checks if `point` is inside `bounds`.
  """
  @spec inside?(t, Point.t) :: boolean
  def inside?(bounds, point)
  def inside?(%Bounds{min_point: {min_x, min_y}, max_point: {max_x, max_y}}, {x, y}) do
    x >= min_x && x <= max_x && y >= min_y && y <= max_y
  end
  def inside?(%Bounds{min_point: {min_x, min_y, min_z}, max_point: {max_x, max_y, max_z}},
              {x, y, z}) do
    x >= min_x && x <= max_x && y >= min_y && y <= max_y && z >= min_z && z <= max_z
  end

  @doc """
  Checks if `point` is inside `bounds` excluding the upper boundary of `bounds`.
  """
  @spec inside_exclusive?(t, Point.t) :: boolean
  def inside_exclusive?(bounds, point)
  def inside_exclusive?(%Bounds{min_point: {min_x, min_y}, max_point: {max_x, max_y}}, {x, y}) do
    x >= min_x && x < max_x && y >= min_y && y < max_y
  end
  def inside_exclusive?(%Bounds{min_point: {min_x, min_y, min_z}, max_point: {max_x, max_y, max_z}},
                        {x, y, z}) do
    x >= min_x && x < max_x && y >= min_y && y < max_y && z < max_z && z >= min_z
  end

  @doc """
  Compute the bounding box that is the intersection of `bounds1` and `bounds2`.
  """
  @spec intersect(t, t) :: t
  def intersect(bounds1, bounds2)
  def intersect(%Bounds{min_point: {min_x1, min_y1}, max_point: {max_x1, max_y1}},
                %Bounds{min_point: {min_x2, min_y2}, max_point: {max_x2, max_y2}}) do
    %Bounds{min_point: {max(min_x1, min_x2), max(min_y1, min_y2)},
            max_point: {min(max_x1, max_x2), min(max_y1, max_y2)}}
  end
  def intersect(%Bounds{min_point: {min_x1, min_y1, min_z1},
                        max_point: {max_x1, max_y1, max_z1}},
                %Bounds{min_point: {min_x2, min_y2, min_z2},
                        max_point: {max_x2, max_y2, max_z2}}) do
    %Bounds{min_point: {max(min_x1, min_x2), max(min_y1, min_y2), max(min_z1, min_z2)},
            max_point: {min(max_x1, max_x2), min(max_y1, max_y2), min(max_z1, max_z2)}}
  end

  @doc """
  Linearly interpolates the point between the minimum and maximum corners of
  `bounds` by the given amount in each direction specified by the x, y, and z
  values of the map `values`.
  """
  @spec lerp(t, %{tx: number, ty: number, tz: number}) :: Point.t
  def lerp(bounds, values)
  def lerp(%Bounds{min_point: {min_x, min_y}, max_point: {max_x, max_y}}, %{tx: tx, ty: ty}) do
    {Geometry.lerp(min_x, max_x, tx), Geometry.lerp(min_y, max_y, ty)}
  end
  def lerp(%Bounds{min_point: {min_x, min_y, min_z}, max_point: {max_x, max_y, max_z}},
           %{tx: tx, ty: ty, tz: tz}) do
    {Geometry.lerp(min_x, max_x, tx),
     Geometry.lerp(min_y, max_y, ty),
     Geometry.lerp(min_z, max_z, tz)}
  end

  @doc """
  Returns either `:x`, `:y`, or `:z` indicating the direction of the largest
  extent of `bounds`.
  """
  @spec maximum_extent(t) :: atom
  def maximum_extent(bounds) do
    bounds |> diagonal |> find_largest_extent
  end

  defp find_largest_extent({dx, dy}) when dx > dy, do: :x
  defp find_largest_extent({_, _}), do: :y
  defp find_largest_extent({dx, dy, dz}) when dx > dy and dx > dz, do: :x
  defp find_largest_extent({dy, _, dz}) when dy > dz, do: :y
  defp find_largest_extent({_, _, _}), do: :z

  @doc """
  Returns the continuous position of `point` relative to the minimum and maximum
  corners of `bounds`. A point at the minimum corner has an offset of (0, 0, 0)
  and a point at the maximum corner has an offset of (1, 1, 1).
  """
  @spec offset(t, Point.t) :: {number, number} | {number, number, number}
  def offset(%Bounds{min_point: {_, _}, max_point: {_, _}} = bounds, point) do
    {offset_x(bounds, point), offset_y(bounds, point)}
  end
  def offset(%Bounds{min_point: {_, _, _}, max_point: {_, _, _}} = bounds, point) do
    {offset_x(bounds, point), offset_y(bounds, point), offset_z(bounds, point)}
  end

  defp offset_x(%Bounds{min_point: min_point, max_point: max_point}, point) do
    min_x = elem(min_point, 0)
    max_x = elem(max_point, 0)
    x = elem(point, 0)
    if max_x > min_x do
      (x - min_x) / (max_x - min_x)
    else
      x - min_x
    end
  end

  defp offset_y(%Bounds{min_point: min_point, max_point: max_point}, point) do
    min_y = elem(min_point, 1)
    max_y = elem(max_point, 1)
    y = elem(point, 1)
    if max_y > min_y do
      (y - min_y) / (max_y - min_y)
    else
      y - min_y
    end
  end

  defp offset_z(%Bounds{min_point: min_point, max_point: max_point}, point) do
    min_z = elem(min_point, 2)
    max_z = elem(max_point, 2)
    z = elem(point, 2)
    if max_z > min_z do
      (z - min_z) / (max_z - min_z)
    else
      z - min_z
    end
  end

  @doc """
  Checks if `bounds1` and `bounds2` overlap.
  """
  @spec overlap?(t, t) :: boolean
  def overlap?(bounds1, bounds2)
  def overlap?(%Bounds{min_point: {min_x1, min_y1}, max_point: {max_x1, max_y1}},
               %Bounds{min_point: {min_x2, min_y2}, max_point: {max_x2, max_y2}}) do
    max_x1 >= min_x2 && min_x1 <= max_x2 && max_y1 >= min_y2 && min_y1 <= max_y2
  end
  def overlap?(%Bounds{min_point: {min_x1, min_y1, min_z1}, max_point: {max_x1, max_y1, max_z1}},
               %Bounds{min_point: {min_x2, min_y2, min_z2}, max_point: {max_x2, max_y2, max_z2}}) do
    max_x1 >= min_x2 && min_x1 <= max_x2 &&
    max_y1 >= min_y2 && min_y1 <= max_y2 &&
    max_z1 >= min_z2 && min_z1 <= max_z2
  end

  @doc """
  Given a bounding box and a point, this function computes a new bounding box
  that encompasses both the bounding box and point. Given two bounding boxes,
  this function computes a new bounding box that bounds the space encompassed by
  the two bounding boxes.
  """
  @spec union(t, t | Point.t) :: t
  def union(bounds, bounds_or_point)
  def union(%Bounds{min_point: {min_x1, min_y1}, max_point: {max_x1, max_y1}},
            %Bounds{min_point: {min_x2, min_y2}, max_point: {max_x2, max_y2}}) do
    %Bounds{min_point: {min(min_x1, min_x2), min(min_y1, min_y2)},
            max_point: {max(max_x1, max_x2), max(max_y1, max_y2)}}
  end
  def union(%Bounds{min_point: {min_x1, min_y1, min_z1}, max_point: {max_x1, max_y1, max_z1}},
            %Bounds{min_point: {min_x2, min_y2, min_z2}, max_point: {max_x2, max_y2, max_z2}}) do
    %Bounds{min_point: {min(min_x1, min_x2), min(min_y1, min_y2), min(min_z1, min_z2)},
            max_point: {max(max_x1, max_x2), max(max_y1, max_y2), max(max_z1, max_z2)}}
  end
  def union(%Bounds{min_point: {min_x, min_y}, max_point: {max_x, max_y}}, {x, y}) do
    %Bounds{min_point: {min(min_x, x), min(min_y, y)}, max_point: {max(max_x, x), max(max_y, y)}}
  end
  def union(%Bounds{min_point: {min_x, min_y, min_z}, max_point: {max_x, max_y, max_z}},
            {x, y, z}) do
    %Bounds{min_point: {min(min_x, x), min(min_y, y), min(min_z, z)},
            max_point: {max(max_x, x), max(max_y, y), max(max_z, z)}}
  end
end
