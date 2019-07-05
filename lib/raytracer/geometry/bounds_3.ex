defmodule Raytracer.Geometry.Bounds3 do
  @moduledoc """
  This module provides functions for working with three dimensional axis-aligned bounding boxes.
  """

  alias __MODULE__
  alias Raytracer.{Geometry, Transformable}
  alias Raytracer.Geometry.{Point3, Vector3}

  defstruct min: %Point3{}, max: %Point3{}

  @type t :: %Bounds3{min: Point3.t(), max: Point3.t()}

  @doc """
  Return the corner point of `bounds` with index equal to `index`.
  """
  @spec corner(t, 0..7) :: Point3.t()
  def corner(bounds, index)
  def corner(bounds, 0), do: bounds.min
  def corner(bounds, 1), do: %Point3{x: bounds.max.x, y: bounds.min.y, z: bounds.min.z}
  def corner(bounds, 2), do: %Point3{x: bounds.min.x, y: bounds.max.y, z: bounds.min.z}
  def corner(bounds, 3), do: %Point3{x: bounds.max.x, y: bounds.max.y, z: bounds.min.z}
  def corner(bounds, 4), do: %Point3{x: bounds.min.x, y: bounds.min.y, z: bounds.max.z}
  def corner(bounds, 5), do: %Point3{x: bounds.max.x, y: bounds.min.y, z: bounds.max.z}
  def corner(bounds, 6), do: %Point3{x: bounds.min.x, y: bounds.max.y, z: bounds.max.z}
  def corner(bounds, 7), do: bounds.max

  @doc """
  Compute the vector along the diagonal of `bounds` from the minimum point to the maximum point.
  """
  @spec diagonal(t) :: Vector3.t()
  def diagonal(bounds), do: Point3.subtract(bounds.max, bounds.min)

  @doc """
  Pads `bounds` in all directions by the value of `delta`.
  """
  @spec expand(t, float) :: t
  def expand(bounds, delta) do
    v = %Vector3{dx: delta, dy: delta, dz: delta}
    %Bounds3{min: Point3.subtract(bounds.min, v), max: Point3.add(bounds.max, v)}
  end

  @doc """
  Checks if `point` is inside `bounds`.
  """
  @spec inside?(t, Point3.t()) :: boolean
  def inside?(bounds, point) do
    point.x >= bounds.min.x && point.x <= bounds.max.x &&
      point.y >= bounds.min.y && point.y <= bounds.max.y &&
      point.z >= bounds.min.z && point.z <= bounds.max.z
  end

  @doc """
  Checks if `point` is inside `bounds` excluding the upper boundary of `bounds`.
  """
  @spec inside_exclusive?(t, Point3.t()) :: boolean
  def inside_exclusive?(bounds, point) do
    point.x >= bounds.min.x && point.x < bounds.max.x &&
      point.y >= bounds.min.y && point.y < bounds.max.y &&
      point.z < bounds.max.z && point.z >= bounds.min.z
  end

  @doc """
  Compute the bounding box that is the intersection of `bounds1` and `bounds2`.
  """
  @spec intersect(t, t) :: t
  def intersect(bounds1, bounds2) do
    %Bounds3{
      min: %Point3{
        x: max(bounds1.min.x, bounds2.min.x),
        y: max(bounds1.min.y, bounds2.min.y),
        z: max(bounds1.min.z, bounds2.min.z)
      },
      max: %Point3{
        x: min(bounds1.max.x, bounds2.max.x),
        y: min(bounds1.max.y, bounds2.max.y),
        z: min(bounds1.max.z, bounds2.max.z)
      }
    }
  end

  @doc """
  Linearly interpolates the point between the minimum and maximum corners of `bounds` by the given
  amount in each direction specified by the tx, ty, and tz values.
  """
  @spec lerp(t, float, float, float) :: Point3.t()
  def lerp(bounds, tx, ty, tz) do
    %Point3{
      x: Geometry.lerp(bounds.min.x, bounds.max.x, tx),
      y: Geometry.lerp(bounds.min.y, bounds.max.y, ty),
      z: Geometry.lerp(bounds.min.z, bounds.max.z, tz)
    }
  end

  @doc """
  Returns either `:x`, `:y`, or `:z` indicating the direction of the largest extent of `bounds`.
  """
  @spec maximum_extent(t) :: :x | :y | :z
  def maximum_extent(bounds), do: bounds |> diagonal() |> find_largest_extent()

  defp find_largest_extent(%Vector3{dx: dx, dy: dy, dz: dz}) when dx > dy and dx > dz, do: :x
  defp find_largest_extent(%Vector3{dy: dy, dz: dz}) when dy > dz, do: :y
  defp find_largest_extent(_), do: :z

  @doc """
  Returns the continuous position of `point` relative to the minimum and maximum corners of
  `bounds`. A point at the minimum corner has an offset of (0, 0, 0) and a point at the maximum
  corner has an offset of (1, 1, 1).
  """
  @spec offset(t, Point3.t()) :: {float, float, float}
  def offset(bounds, point) do
    {offset_x(bounds, point), offset_y(bounds, point), offset_z(bounds, point)}
  end

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

  defp offset_z(bounds, point) do
    if bounds.max.z > bounds.min.z do
      (point.z - bounds.min.z) / (bounds.max.z - bounds.min.z)
    else
      point.z - bounds.min.z
    end
  end

  @doc """
  Checks if `bounds1` and `bounds2` overlap.
  """
  @spec overlap?(t, t) :: boolean
  def overlap?(bounds1, bounds2) do
    bounds1.max.x >= bounds2.min.x && bounds1.min.x <= bounds2.max.x &&
      bounds1.max.y >= bounds2.min.y && bounds1.min.y <= bounds2.max.y &&
      bounds1.max.z >= bounds2.min.z && bounds1.min.z <= bounds2.max.z
  end

  @doc """
  Given a bounding box and a point, this function computes a new bounding box that encompasses both
  the bounding box and point. Given two bounding boxes, this function computes a new bounding box
  that bounds the space encompassed by the two bounding boxes.
  """
  @spec union(t, t | Point3.t()) :: t
  def union(bounds, bounds_or_point)

  def union(bounds1, %Bounds3{} = bounds2) do
    %Bounds3{
      min: %Point3{
        x: min(bounds1.min.x, bounds2.min.x),
        y: min(bounds1.min.y, bounds2.min.y),
        z: min(bounds1.min.z, bounds2.min.z)
      },
      max: %Point3{
        x: max(bounds1.max.x, bounds2.max.x),
        y: max(bounds1.max.y, bounds2.max.y),
        z: max(bounds1.max.z, bounds2.max.z)
      }
    }
  end

  def union(bounds, %Point3{} = point) do
    %Bounds3{
      min: %Point3{
        x: min(bounds.min.x, point.x),
        y: min(bounds.min.y, point.y),
        z: min(bounds.min.z, point.z)
      },
      max: %Point3{
        x: max(bounds.max.x, point.x),
        y: max(bounds.max.y, point.y),
        z: max(bounds.max.z, point.z)
      }
    }
  end

  defimpl Transformable do
    def apply_transform(bounds, t) do
      %Point3{x: min_x, y: min_y, z: min_z} = bounds.min
      %Point3{x: max_x, y: max_y, z: max_z} = bounds.max

      bounds
      |> Bounds3.union(Transformable.apply_transform(%Point3{x: min_x, y: min_y, z: min_z}, t))
      |> Bounds3.union(Transformable.apply_transform(%Point3{x: max_x, y: min_y, z: min_z}, t))
      |> Bounds3.union(Transformable.apply_transform(%Point3{x: min_x, y: max_y, z: min_z}, t))
      |> Bounds3.union(Transformable.apply_transform(%Point3{x: min_x, y: min_y, z: max_z}, t))
      |> Bounds3.union(Transformable.apply_transform(%Point3{x: max_x, y: max_y, z: min_z}, t))
      |> Bounds3.union(Transformable.apply_transform(%Point3{x: max_x, y: min_y, z: max_z}, t))
      |> Bounds3.union(Transformable.apply_transform(%Point3{x: max_x, y: max_y, z: max_z}, t))
    end
  end
end
