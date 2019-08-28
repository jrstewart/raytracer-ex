defmodule Raytracer.CLI do
  @moduledoc """
  Command line interface functions for the Raytracer program.
  """

  alias Raytracer.{ColorRGB, Renderer, Scene, TGAImage}

  @doc """
  Runs the Raytracer program with given arguments.
  """
  @spec run([binary]) :: :ok
  def run(argv) do
    argv |> parse_args() |> process()
  end

  defp parse_args(argv) do
    switches = [
      help: :boolean,
      output_file: :string,
      renderer_file: :string,
      scene_file: :string,
      suggest_scale: :boolean
    ]

    aliases = [r: :renderer_file, s: :scene_file, o: :output_file, h: :help]

    argv
    |> OptionParser.parse(switches: switches, aliases: aliases)
    |> case do
      {[help: true], _, _} ->
        :help

      {[renderer_file: _, scene_file: _, output_file: _] = args, _, _} ->
        {:render, args}

      {[renderer_file: _, scene_file: _, output_file: _, suggest_scale: _] = args, _, _} ->
        {:render, args}

      _ ->
        :help
    end
  end

  defp process(:help) do
    IO.puts("""
    Usage:

    --output-file, -o
      File location where the renderered file will be saved.

    --renderer-file, -r
      Path to the JSON file containing the renderer data.

    --scene-file, -s
      Path to the JSON file containing the scene data.

    --suggest-scale
      Provide a suggested RGB scale factor to use for the renderer based on the max RGB values
      of the rendered scene.
    """)

    :ok
  end

  defp process({:render, args}) do
    {:ok, renderer} = args |> Keyword.fetch!(:renderer_file) |> Renderer.from_file()
    {:ok, scene} = args |> Keyword.fetch!(:scene_file) |> Scene.from_file()

    IO.puts("Rendering scene...")
    start_time = Time.utc_now()
    {:ok, pixel_data} = Renderer.render_scene(renderer, scene)
    end_time = Time.utc_now()
    run_time = Time.diff(end_time, start_time, :millisecond)
    IO.puts("Rendering time: #{run_time / 1000.0}s")

    IO.puts("Writing file...")
    color_data = pixel_data |> Enum.map(&ColorRGB.to_binary(&1)) |> Enum.join()

    :ok =
      %TGAImage{width: renderer.camera.width, height: renderer.camera.height}
      |> TGAImage.write(Keyword.fetch!(args, :output_file), color_data)

    if Keyword.get(args, :suggest_scale) do
      suggest_rgb_scale_factor(pixel_data)
    end

    :ok
  end

  defp suggest_rgb_scale_factor(pixel_data) do
    max_value = pixel_data |> Enum.flat_map(&[&1.red, &1.green, &1.blue]) |> Enum.max()
    IO.puts("suggests RGB scale factor: #{1.0 / max_value}")
  end
end
