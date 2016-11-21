defmodule Raytracer.Geometry.Bounds3 do
  @moduledoc """
  Axis-aligned three-dimensional bounding box.
  """

  alias __MODULE__
  alias Raytracer.Geometry
  alias Raytracer.Geometry.{Point3, Vector3}

  defstruct [
    min_point: %Point3{},
    max_point: %Point3{},
  ]

  @type t :: %Bounds3{min_point: Point3.t, max_point: Point3.t}

  @doc """
  Return the corner point of `bounds` with index equal to `index`.
  """
  @spec corner(t, 0..7) :: Point3.t
  def corner(bounds, index)

  def corner(%Bounds3{min_point: min_point}, 0) do
    min_point
  end

  def corner(%Bounds3{min_point: %Point3{y: y, z: z}, max_point: %Point3{x: x}}, 1) do
    %Point3{x: x, y: y, z: z}
  end

  def corner(%Bounds3{min_point: %Point3{x: x, z: z}, max_point: %Point3{y: y}}, 2) do
    %Point3{x: x, y: y, z: z}
  end

  def corner(%Bounds3{min_point: %Point3{z: z}, max_point: %Point3{x: x, y: y}}, 3) do
    %Point3{x: x, y: y, z: z}
  end

  def corner(%Bounds3{min_point: %Point3{x: x, y: y}, max_point: %Point3{z: z}}, 4) do
    %Point3{x: x, y: y, z: z}
  end

  def corner(%Bounds3{min_point: %Point3{y: y}, max_point: %Point3{x: x, z: z}}, 5) do
    %Point3{x: x, y: y, z: z}
  end

  def corner(%Bounds3{min_point: %Point3{x: x}, max_point: %Point3{y: y, z: z}}, 6) do
    %Point3{x: x, y: y, z: z}
  end

  def corner(%Bounds3{max_point: max_point}, 7) do
    max_point
  end

  @doc """
  Compute the vector along the diagonal of `bounds` from the minimum point to the
  maximum point.
  """
  @spec diagonal(t) :: Vector3.t
  def diagonal(bounds)

  def diagonal(%Bounds3{min_point: min_point, max_point: max_point}) do
    Point3.subtract(max_point, min_point)
  end

  @doc """
  Pads `bounds` in all directions by the value of `delta`.
  """
  @spec expand(t, number) :: t
  def expand(bounds, delta)

  def expand(%Bounds3{min_point: min_point, max_point: max_point}, delta) do
    v = %Vector3{dx: delta, dy: delta, dz: delta}
    %Bounds3{
      min_point: min_point |> Point3.subtract(v),
      max_point: max_point |> Point3.add(v),
    }
  end

  @doc """
  Checks if `point` is inside `bounds`.
  """
  @spec inside?(t, Point3.t) :: boolean
  def inside?(bounds, point)

  def inside?(
    %Bounds3{
      min_point: %Point3{x: min_x, y: min_y, z: min_z},
      max_point: %Point3{x: max_x, y: max_y, z: max_z},
    },
    %Point3{x: x, y: y, z: z}
  ) do
    x >= min_x && x <= max_x && y >= min_y && y <= max_y && z >= min_z && z <= max_z
  end

  @doc """
  Checks if `point` is inside `bounds` excluding the upper boundary of `bounds`.
  """
  @spec inside_exclusive?(t, Point3.t) :: boolean
  def inside_exclusive?(bounds, point)

  def inside_exclusive?(
    %Bounds3{
      min_point: %Point3{x: min_x, y: min_y, z: min_z},
      max_point: %Point3{x: max_x, y: max_y, z: max_z},
    },
    %Point3{x: x, y: y, z: z}
  ) do
    x >= min_x && x < max_x && y >= min_y && y < max_y && z < max_z && z >= min_z
  end

  @doc """
  Compute the bounding box that is the intersection of `bounds1` and `bounds2`.
  """
  @spec intersect(t, t) :: t
  def intersect(bounds1, bounds2)

  def intersect(
    %Bounds3{
      min_point: %Point3{x: min_x1, y: min_y1, z: min_z1},
      max_point: %Point3{x: max_x1, y: max_y1, z: max_z1},
    },
    %Bounds3{
      min_point: %Point3{x: min_x2, y: min_y2, z: min_z2},
      max_point: %Point3{x: max_x2, y: max_y2, z: max_z2},
    }
  ) do
    %Bounds3{
      min_point: %Point3{x: max(min_x1, min_x2), y: max(min_y1, min_y2), z: max(min_z1, min_z2)},
      max_point: %Point3{x: min(max_x1, max_x2), y: min(max_y1, max_y2), z: min(max_z1, max_z2)},
    }
  end

  @doc """
  Linearly interpolates the point between the minimum and maximum corners of
  `bounds` by the given amount in each direction specified by the x, y, and z
  values of the map `values`.
  """
  @spec lerp(t, %{tx: number, ty: number, tz: number}) :: Point3.t
  def lerp(bounds, values)

  def lerp(
    %Bounds3{
      min_point: %Point3{x: min_x, y: min_y, z: min_z},
      max_point: %Point3{x: max_x, y: max_y, z: max_z},
    },
    %{tx: tx, ty: ty, tz: tz}
  ) do
    %Point3{
      x: Geometry.lerp(min_x, max_x, tx),
      y: Geometry.lerp(min_y, max_y, ty),
      z: Geometry.lerp(min_z, max_z, tz),
    }
  end

  @doc """
  Returns either `:x`, `:y`, or `:z` indicating the direction of the largest
  extent of `bounds`.
  """
  @spec maximum_extent(t) :: atom
  def maximum_extent(bounds) do
    bounds
    |> diagonal
    |> find_largest_extent
  end

  defp find_largest_extent(%Vector3{dx: dx, dy: dy, dz: dz}) when dx > dy and dx > dz, do: :x
  defp find_largest_extent(%Vector3{dy: dy, dz: dz}) when dy > dz, do: :y
  defp find_largest_extent(_), do: :z

  @doc """
  Returns the continuous position of `point` relative to the minimum and maximum
  corners of `bounds`. A point at the minimum corner has an offset of (0, 0, 0)
  and a point at the maximum corner has an offset of (1, 1, 1).
  """
  @spec offset(t, Point3.t) :: %{x: number, y: number, z: number}
  def offset(bounds, point) do
    %{x: offset_x(bounds, point), y: offset_y(bounds, point), z: offset_z(bounds, point)}
  end

  defp offset_x(
    %Bounds3{min_point: %Point3{x: min_x}, max_point: %Point3{x: max_x}},
    %Point3{x: x}
  ) when max_x > min_x do
    (x - min_x) / (max_x - min_x)
  end

  defp offset_x(%Bounds3{min_point: %Point3{x: min_x}}, %Point3{x: x}) do
    x - min_x
  end

  defp offset_y(
    %Bounds3{min_point: %Point3{y: min_y}, max_point: %Point3{y: max_y}},
    %Point3{y: y}
  ) when max_y > min_y do
    (y - min_y) / (max_y - min_y)
  end

  defp offset_y(%Bounds3{min_point: %Point3{y: min_y}}, %Point3{y: y}) do
    y - min_y
  end

  defp offset_z(
    %Bounds3{min_point: %Point3{z: min_z}, max_point: %Point3{z: max_z}},
    %Point3{z: z}
  ) when max_z > min_z do
    (z - min_z) / (max_z - min_z)
  end

  defp offset_z(%Bounds3{min_point: %Point3{z: min_z}}, %Point3{z: z}) do
    z - min_z
  end

  @doc """
  Checks if `bounds1` and `bounds2` overlap.
  """
  @spec overlap?(t, t) :: boolean
  def overlap?(bounds1, bounds2)

  def overlap?(
    %Bounds3{
      min_point: %Point3{x: min_x1, y: min_y1, z: min_z1},
      max_point: %Point3{x: max_x1, y: max_y1, z: max_z1},
    },
    %Bounds3{
      min_point: %Point3{x: min_x2, y: min_y2, z: min_z2},
      max_point: %Point3{x: max_x2, y: max_y2, z: max_z2},
    }
  ) do
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
  @spec union(t, t | Point3.t) :: t
  def union(bounds, bounds_or_point)

  def union(
    %Bounds3{
      min_point: %Point3{x: min_x1, y: min_y1, z: min_z1},
      max_point: %Point3{x: max_x1, y: max_y1, z: max_z1},
    },
    %Bounds3{
      min_point: %Point3{x: min_x2, y: min_y2, z: min_z2},
      max_point: %Point3{x: max_x2, y: max_y2, z: max_z2},
    }
  ) do
    %Bounds3{
      min_point: %Point3{x: min(min_x1, min_x2), y: min(min_y1, min_y2), z: min(min_z1, min_z2)},
      max_point: %Point3{x: max(max_x1, max_x2), y: max(max_y1, max_y2), z: max(max_z1, max_z2)},
    }
  end

  def union(
    %Bounds3{
      min_point: %Point3{x: min_x, y: min_y, z: min_z},
      max_point: %Point3{x: max_x, y: max_y, z: max_z},
    },
    %Point3{x: x, y: y, z: z}
  ) do
    %Bounds3{
      min_point: %Point3{x: min(min_x, x), y: min(min_y, y), z: min(min_z, z)},
      max_point: %Point3{x: max(max_x, x), y: max(max_y, y), z: max(max_z, z)},
    }
  end
end
