defmodule Raytracer.ColorRGB do
  @moduledoc """
  This module provides a set of functions for working with an RGB color value.
  """

  alias __MODULE__

  defstruct red: 0.0, green: 0.0, blue: 0.0

  @type t :: %ColorRGB{red: float(), green: float(), blue: float()}

  @doc """
  Adds the RGB values of two colors and returns the resulting color.

  ## Examples

      iex> c1 = %ColorRGB{red: 0.5, green: 0.0, blue: 0.25}
      iex> c2 = %ColorRGB{red: 0.2, green: 0.3, blue: 0.5}
      iex> ColorRGB.add(c1, c2)
      %ColorRGB{red: 0.7, green: 0.3, blue: 0.75}

  """
  @spec add(t(), t()) :: t()
  def add(color1, color2) do
    %ColorRGB{
      red: color1.red + color2.red,
      green: color1.green + color2.green,
      blue: color1.blue + color2.blue
    }
  end

  @doc """
  Returns the ColorRGB representation of the color black.

  ## Examples

      iex> ColorRGB.black()
      %ColorRGB{red: 0.0, green: 0.0, blue: 0.0}

  """
  @spec black() :: t()
  def black(), do: %ColorRGB{red: 0.0, green: 0.0, blue: 0.0}

  @doc """
  Checks if any of the RGB values of `color` are greater than 1.0 and scales the color based on the
  largest value.

  ## Examples

      iex> c = %ColorRGB{red: 2.0, green: 0.5, blue: 1.0}
      iex> ColorRGB.clamp(c)
      %ColorRGB{red: 1.0, green: 0.25, blue: 0.5}

      iex> c = %ColorRGB{red: 1.0, green: 0.0, blue: 0.25}
      iex> ColorRGB.clamp(c)
      %ColorRGB{red: 1.0, green: 0.0, blue: 0.25}

  """
  @spec clamp(t()) :: t()
  def clamp(color) do
    max =
      cond do
        color.red > color.green && color.red > color.blue ->
          color.red

        color.green > color.blue ->
          color.green

        true ->
          color.blue
      end

    if max > 1.0, do: multiply(color, 1.0 / max), else: color
  end

  @doc """
  Multiplies the RGB values of two colors together or multiplies the RGB values of a color by a
  scalar value and returns the resulting color.

  ## Examples

      iex> c1 = %ColorRGB{red: 1.0, green: 0.0, blue: 0.25}
      iex> c2 = %ColorRGB{red: 0.5, green: 0.3, blue: 0.5}
      iex> ColorRGB.multiply(c1, c2)
      %ColorRGB{red: 0.5, green: 0.0, blue: 0.125}

      iex> c1 = %ColorRGB{red: 1.0, green: 0.0, blue: 0.25}
      iex> ColorRGB.multiply(c1, 0.5)
      %ColorRGB{red: 0.5, green: 0.0, blue: 0.125}

  """
  @spec multiply(t(), t() | float()) :: t()
  def multiply(color1, %ColorRGB{} = color2) do
    %ColorRGB{
      red: color1.red * color2.red,
      green: color1.green * color2.green,
      blue: color1.blue * color2.blue
    }
  end

  def multiply(color, scalar) do
    %ColorRGB{
      red: color.red * scalar,
      green: color.green * scalar,
      blue: color.blue * scalar
    }
  end

  @doc """
  Converts the RGB values of `color` into binary with color values between 0 and 255.

  ## Examples

      iex> c = %ColorRGB{red: 0.5, green: 0.3, blue: 0.1}
      iex> ColorRGB.to_binary(c)
      <<127, 76, 25>>

  """
  @spec to_binary(t()) :: binary()
  def to_binary(color) do
    <<trunc(color.red * 255), trunc(color.green * 255), trunc(color.blue * 255)>>
  end

  @doc """
  Returns the ColorRGB representation of the color white.

  ## Examples

      iex> ColorRGB.white()
      %ColorRGB{red: 1.0, green: 1.0, blue: 1.0}

  """
  @spec white() :: t()
  def white(), do: %ColorRGB{red: 1.0, green: 1.0, blue: 1.0}
end
