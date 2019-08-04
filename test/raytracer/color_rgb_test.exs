defmodule Raytracer.ColorRGBTest do
  use ExUnit.Case, async: true
  use PropCheck
  import Raytracer.Generators
  alias Raytracer.ColorRGB

  @delta 1.0e-7

  doctest ColorRGB

  describe "add/2" do
    property "subtracting one of the color's RGB values from the resulting color returns the other color" do
      forall {c1, c2} <- {color_rgb(), color_rgb()} do
        result = ColorRGB.add(c1, c2)
        assert_in_delta result.red - c2.red, c1.red, @delta
        assert_in_delta result.green - c2.green, c1.green, @delta
        assert_in_delta result.blue - c2.blue, c1.blue, @delta
      end
    end
  end

  describe "clamp/1" do
    property "returns a color with RGB values less than or equal to 1" do
      forall c <- unbound_color_rgb() do
        result = ColorRGB.clamp(c)
        assert result.red <= 1.0
        assert result.green <= 1.0
        assert result.blue <= 1.0
      end
    end
  end

  describe "multiply/2" do
    property "dividing the resulting color by the on of the color's RGB values returns the other color" do
      forall {c1, c2} <- {color_rgb(), color_rgb()} do
        result = ColorRGB.multiply(c1, c2)
        assert_in_delta result.red / c2.red, c1.red, @delta
        assert_in_delta result.green / c2.green, c1.green, @delta
        assert_in_delta result.blue / c2.blue, c1.blue, @delta
      end
    end

    property "dividing the resulting color by the scalar returns the original color" do
      forall {c, scalar} <- {color_rgb(), non_zero_float()} do
        result = ColorRGB.multiply(c, scalar)
        assert_in_delta result.red / scalar, c.red, @delta
        assert_in_delta result.green / scalar, c.green, @delta
        assert_in_delta result.blue / scalar, c.blue, @delta
      end
    end
  end
end
