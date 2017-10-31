defmodule Raytracer.Geometry.Vector2Test do
  use ExUnit.Case, async: true

  alias Raytracer.Geometry.Vector2

  describe "Raytracer.Geometry.Vector2.length/1" do
    test "computes the length of a vector" do
      vector = %Vector2{dx: 1.0, dy: 2.0}

      assert_in_delta Vector2.length(vector), 2.236067977, 1.0e-7
    end
  end

  describe "Raytracer.Geometry.Vector2.length_squared/1" do
    test "computes the squared length of a vector" do
      vector = %Vector2{dx: 1.0, dy: 2.0}

      assert_in_delta Vector2.length_squared(vector), 5.0, 1.0e-7
    end
  end
end
