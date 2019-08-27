defmodule Raytracer.RendererTest do
  use ExUnit.Case, async: true
  alias Raytracer.{Camera, ColorRGB, Renderer, Scene}

  @test_dir "test/support/test_data/"
  @renderer_data %{
    "camera" => %{
      "center" => [10.0, 0.0, 0.0],
      "distance" => 10.0,
      "eye" => [0.0, 0.0, 10.0],
      "height" => 20,
      "width" => 20,
      "wc_window" => [-10.0, 10.0, -10.0, 10.0],
      "up" => [0.0, 1.0, 0.0]
    },
    "ambient_light_color" => [0.0, 0.0, 0.0],
    "attenuation_cutoff" => 0.1,
    "background_color" => [1.0, 0.0, 0.0],
    "global_rgb_scale" => 0.0,
    "max_recursive_depth" => 4,
    "supersample_size" => 2
  }

  describe "from_file/1" do
    test "builds a renderer from the given file" do
      file = @test_dir <> "test_renderer.json"

      assert {:ok, renderer} = Renderer.from_file(file)
      assert renderer.ambient_light_color == %ColorRGB{red: 0.2, green: 0.4, blue: 0.6}
      assert renderer.attenuation_cutoff == 0.2
      assert renderer.background_color == %ColorRGB{red: 1.0, green: 0.8, blue: 0.7}
      assert renderer.global_rgb_scale == 0.5
      assert renderer.max_recursive_depth == 6
      assert renderer.supersample_size == 4
      assert %Camera{} = renderer.camera
    end
  end

  describe "render_scene/2" do
    test "renders the scene" do
      scene_file = "test/support/test_data/test_scene.json"
      {:ok, scene} = Scene.from_file(scene_file)
      {:ok, renderer} = Renderer.parse(@renderer_data)
      pixel_data = Renderer.render_scene(renderer, scene)
      expected = File.read!(@test_dir <> "pixel_data.bin") |> :erlang.binary_to_term()

      assert pixel_data == expected
    end

    test "each pixel color is set to the renderer's background color when the scene is empty" do
      scene = %Scene{light_sources: [], models: []}
      {:ok, renderer} = Renderer.parse(@renderer_data)
      {:ok, pixel_data} = Renderer.render_scene(renderer, scene)

      Enum.each(pixel_data, &assert(&1 == renderer.background_color))
    end
  end

  describe "parse/1" do
    test "parses the renderer data from the given map" do
      data = %{
        "camera" => %{
          "center" => [-10.0, -11.0, -12.0],
          "distance" => 50.0,
          "eye" => [5.0, 6.0, 7.0],
          "height" => 256,
          "width" => 512,
          "wc_window" => [-10.0, 10.0, -20.0, 20.0],
          "up" => [0.0, 2.0, 0.0]
        },
        "ambient_light_color" => [0.2, 0.4, 0.6],
        "attenuation_cutoff" => 0.2,
        "background_color" => [1.0, 0.8, 0.7],
        "global_rgb_scale" => 0.5,
        "max_recursive_depth" => 6,
        "supersample_size" => 4
      }

      assert {:ok, renderer} = Renderer.parse(data)
      assert renderer.ambient_light_color == %ColorRGB{red: 0.2, green: 0.4, blue: 0.6}
      assert renderer.attenuation_cutoff == 0.2
      assert renderer.background_color == %ColorRGB{red: 1.0, green: 0.8, blue: 0.7}
      assert renderer.global_rgb_scale == 0.5
      assert renderer.max_recursive_depth == 6
      assert renderer.supersample_size == 4
    end

    test "returns an error if parsing failed" do
      data = %{"attenuation_cutoff" => 0.1}
      assert {:error, message} = Renderer.parse(data)
      assert message == "error parsing renderer"
    end
  end
end
