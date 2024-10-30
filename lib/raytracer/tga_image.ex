defmodule Raytracer.TGAImage do
  @moduledoc """
  This module provides a struct and a set of functions for working with TARGA image files.
  """

  alias __MODULE__

  defstruct id_length: 0,
            color_map_type: 0,
            image_type: 2,
            color_map_specification: %{first_entry_index: 0, num_entries: 0, entry_size: 0},
            x_origin: 0,
            y_origin: 0,
            width: 0,
            height: 0,
            pixel_depth: 24,
            descriptor: 0

  @type t :: %TGAImage{
          id_length: 0..255,
          color_map_type: 0..255,
          image_type: 0..255,
          color_map_specification: %{
            first_entry_index: 0..65_535,
            num_entries: 0..65_535,
            entry_size: 0..255
          },
          x_origin: 0..65_535,
          y_origin: 0..65_535,
          width: 0..65_535,
          height: 0..65_535,
          pixel_depth: 24,
          descriptor: 0..255
        }

  @doc """
  Writes the `image` and `pixel_stream` data to the file at the specified `path`.
  """
  @spec write(t(), Path.t(), Enumerable.t()) :: :ok
  def write(image, path, pixel_stream) do
    File.touch!(path)
    file_stream = File.stream!(path, [:delayed_write])
    pixel_stream = Stream.map(pixel_stream, fn <<pixel::24>> -> <<pixel::little-24>> end)

    [header(image), pixel_stream, footer()]
    |> Stream.concat()
    |> Stream.into(file_stream)
    |> Stream.run()
  end

  defp header(image) do
    [
      <<image.id_length::little-8>>,
      <<image.color_map_type::little-8>>,
      <<image.image_type::little-8>>,
      <<image.color_map_specification.first_entry_index::little-16>>,
      <<image.color_map_specification.num_entries::little-16>>,
      <<image.color_map_specification.entry_size::little-8>>,
      <<image.x_origin::little-16>>,
      <<image.y_origin::little-16>>,
      <<image.width::little-16>>,
      <<image.height::little-16>>,
      <<image.pixel_depth::little-8>>,
      <<image.descriptor::little-8>>
    ]
  end

  defp footer do
    [
      "TRUEVISION-XFILE.",
      :binary.copy(<<0>>, 9)
    ]
  end
end
