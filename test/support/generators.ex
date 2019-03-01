defmodule Raytracer.Generators do
  use PropCheck
  alias Raytracer.Geometry.{Matrix4x4, Point2, Point3, Vector2, Vector3}

  def non_zero_float, do: such_that(n <- float(), when: n != 0.0)

  #
  # Matrix generators
  #

  def affine_matrix4x4 do
    let {m00, m01, m02, m10, m11, m12, m20, m21, m22} <-
          {float(), float(), float(), float(), float(), float(), float(), float(), float()} do
      Matrix4x4.new(
        {m00, m01, m02, 0.0},
        {m10, m11, m12, 0.0},
        {m20, m21, m22, 0.0},
        {0.0, 0.0, 0.0, 1.0}
      )
    end
  end

  def invertable_matrix4x4, do: such_that(m <- matrix4x4(), when: Matrix4x4.determinant(m) != 0)

  def matrix4x4 do
    let {m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33} <-
          {float(), float(), float(), float(), float(), float(), float(), float(), float(), float(),
           float(), float(), float(), float(), float(), float()} do
      Matrix4x4.new(
        {m00, m01, m02, m03},
        {m10, m11, m12, m13},
        {m20, m21, m22, m23},
        {m30, m31, m32, m33}
      )
    end
  end

  #
  # Point and vector generators
  #

  def point2 do
    let {x, y} <- {float(), float()} do
      %Point2{x: x, y: y}
    end
  end

  def point3 do
    let {x, y, z} <- {float(), float(), float()} do
      %Point3{x: x, y: y, z: z}
    end
  end

  def vector2 do
    let {dx, dy} <- {float(), float()} do
      %Vector2{dx: dx, dy: dy}
    end
  end

  def vector3 do
    let {dx, dy, dz} <- {float(), float(), float()} do
      %Vector3{dx: dx, dy: dy, dz: dz}
    end
  end
end
