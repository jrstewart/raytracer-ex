defmodule Raytracer.Shape.PhongTriangle do
  @moduledoc false

  alias __MODULE__
  alias Raytracer.{Parser, Shape}
  alias Raytracer.Geometry.{Ray3, Point3, Vector3}

  @behaviour Parser

  @enforce_keys [:normal1, :normal2, :normal3, :vertex1, :vertex2, :vertex3]
  defstruct [:normal1, :normal2, :normal3, :vertex1, :vertex2, :vertex3]

  @type t :: %PhongTriangle{
          normal1: Vector3.t(),
          normal2: Vector3.t(),
          normal3: Vector3.t(),
          vertex1: Point3.t(),
          vertex2: Point3.t(),
          vertex3: Point3.t()
        }

  @doc """
  Parses the triangle data from `contents` and return a new PhongTriangle struct.
  """
  @impl Parser
  def parse(contents) do
    with {:ok, [[x1, y1, z1], [x2, y2, z2], [x3, y3, z3]]} <- Map.fetch(contents, "vertices"),
         {:ok, [[dx1, dy1, dz1], [dx2, dy2, dz2], [dx3, dy3, dz3]]} <-
           Map.fetch(contents, "normals") do
      {:ok,
       %PhongTriangle{
         vertex1: %Point3{x: x1, y: y1, z: z1},
         normal1: %Vector3{dx: dx1, dy: dy1, dz: dz1} |> Vector3.normalize(),
         vertex2: %Point3{x: x2, y: y2, z: z2},
         normal2: %Vector3{dx: dx2, dy: dy2, dz: dz2} |> Vector3.normalize(),
         vertex3: %Point3{x: x3, y: y3, z: z3},
         normal3: %Vector3{dx: dx3, dy: dy3, dz: dz3} |> Vector3.normalize()
       }}
    else
      _ ->
        {:error, "error parsing triangle"}
    end
  end

  defimpl Shape do
    def compute_intersection(triangle, ray) do
      edge1 = Point3.subtract(triangle.vertex3, triangle.vertex2)
      edge2 = Point3.subtract(triangle.vertex1, triangle.vertex2)
      surface_normal = edge1 |> Vector3.cross(edge2) |> Vector3.normalize()
      bq = Point3.subtract(ray.origin, triangle.vertex1)
      direction_dot_normal = Vector3.dot(ray.direction, surface_normal)

      distance_start_to_intersect =
        if direction_dot_normal == 0.0 do
          -1.0
        else
          -1.0 * (Vector3.dot(bq, surface_normal) / Vector3.dot(ray.direction, surface_normal))
        end

      if distance_start_to_intersect >= 0.0 do
        {:ok, intersection_point} = Ray3.point_at(ray, distance_start_to_intersect)

        check1 =
          check_halfspace_intersection(
            intersection_point,
            surface_normal,
            triangle.vertex1,
            triangle.vertex2
          )

        check2 =
          check_halfspace_intersection(
            intersection_point,
            surface_normal,
            triangle.vertex2,
            triangle.vertex3
          )

        check3 =
          check_halfspace_intersection(
            intersection_point,
            surface_normal,
            triangle.vertex3,
            triangle.vertex1
          )

        if check1 <= 0.0 && check2 <= 0.0 && check3 <= 0.0 do
          distance_start_to_intersect
        else
          nil
        end
      else
        nil
      end
    end

    defp check_halfspace_intersection(intersection_point, surface_normal, vertex1, vertex2) do
      half_space_normal =
        surface_normal
        |> Vector3.cross(Point3.subtract(vertex1, vertex2))
        |> Vector3.normalize()

      intersection_point
      |> Point3.subtract(vertex1)
      |> Vector3.dot(half_space_normal)
    end

    def compute_inward_normal(triangle, point) do
      triangle |> compute_outward_normal(point) |> Vector3.negate()
    end

    def compute_outward_normal(triangle, point) do
      {b1, b2, b3} = compute_barycentric_coordinates(triangle, point)

      %Vector3{dx: 0.0, dy: 0.0, dz: 0.0}
      |> Vector3.add(Vector3.multiply(triangle.normal1, b1))
      |> Vector3.add(Vector3.multiply(triangle.normal2, b2))
      |> Vector3.add(Vector3.multiply(triangle.normal3, b3))
      |> Vector3.normalize()
    end

    defp compute_barycentric_coordinates(triangle, point) do
      area = compute_area(triangle.vertex1, triangle.vertex2, triangle.vertex3)
      b1 = compute_area(point, triangle.vertex2, triangle.vertex3) / area
      b2 = compute_area(triangle.vertex1, point, triangle.vertex3) / area
      b3 = compute_area(triangle.vertex1, triangle.vertex2, point) / area
      {b1, b2, b3}
    end

    defp compute_area(vertex1, vertex2, vertex3) do
      vertex2
      |> Point3.subtract(vertex1)
      |> Vector3.cross(Point3.subtract(vertex3, vertex1))
      |> Vector3.length()
      |> Kernel.*(0.5)
    end
  end
end
