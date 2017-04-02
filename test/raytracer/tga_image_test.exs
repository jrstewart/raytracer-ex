defmodule Raytracer.TGAImageTest do
  use ExUnit.Case, async: true

  alias Raytracer.TGAImage

  @test_dir "test/support/test_data/"

  describe "Raytracer.TGAImage.write/3" do
    test "writes the image file" do
      image = %TGAImage{}
      test_file = @test_dir <> "test_file_1.tga"

      assert TGAImage.write(image, test_file, "") == :ok

      File.rm!(test_file)
    end

    test "writes the image file header" do
      image = %TGAImage{id_length: 12,
                        color_map_type: 2,
                        image_type: 5,
                        color_map_specification: %{first_entry_index: 1024,
                                                   num_entries: 2000,
                                                   entry_size: 24},
                        x_origin: 500,
                        y_origin: 600,
                        width: 1920,
                        height: 1200,
                        pixel_depth: 24,
                        descriptor: 1}
      test_file = @test_dir <> "test_file_2.tga"

      TGAImage.write(image, test_file, "")

      <<id_length::little-8>>
      <> <<color_map_type::little-8>>
      <> <<image_type::little-8>>
      <> <<color_map_first_entry_index::little-16>>
      <> <<color_map_num_entries::little-16>>
      <> <<color_map_entry_size::little-8>>
      <> <<x_origin::little-16>>
      <> <<y_origin::little-16>>
      <> <<width::little-16>>
      <> <<height::little-16>>
      <> <<pixel_depth::little-8>>
      <> <<descriptor::little-8>>
      <> _ = File.read!(test_file)

      assert image.id_length == id_length
      assert image.color_map_type == color_map_type
      assert image.image_type == image_type
      assert image.color_map_specification.first_entry_index == color_map_first_entry_index
      assert image.color_map_specification.num_entries == color_map_num_entries
      assert image.color_map_specification.entry_size == color_map_entry_size
      assert image.x_origin == x_origin
      assert image.y_origin == y_origin
      assert image.width == width
      assert image.height == height
      assert image.pixel_depth == pixel_depth
      assert image.descriptor == descriptor

      File.rm!(test_file)
    end

    test "writes the pixel data" do
      image = %TGAImage{width: 100, height: 100}
      test_file = @test_dir <> "test_file_3.tga"
      pixels =
        1..(image.width * image.height)
        |> Enum.map(&(<<rem(&1, 64), rem(&1, 128), rem(&1, 255)>>))
        |> Enum.join

      TGAImage.write(image, test_file, pixels)
      <<_::binary-18>> <> <<data::binary-30000>> <> _ = File.read!(test_file)

      assert format_pixels(data) == pixels

      File.rm!(test_file)
    end

    defp format_pixels(pixels) do
      for <<pixel::little-24 <- pixels>> do
        <<pixel::24>>
      end
      |> Enum.join
    end

    test "writes the file footer" do
      image = %TGAImage{}
      test_file = @test_dir <> "test_file_4.tga"

      TGAImage.write(image, test_file, "")
      <<_::binary-18>> <> footer = File.read!(test_file)

      assert footer == "TRUEVISION-XFILE." <> :binary.copy(<<0>>, 9)

      File.rm!(test_file)
    end
  end
end
