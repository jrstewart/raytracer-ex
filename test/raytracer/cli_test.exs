defmodule Raytracer.CLITest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias Raytracer.CLI

  describe "Raytracer.CLI.run/1" do
    test "-h option prints the help documentation" do
      assert capture_io(fn ->
               CLI.run(["-h"])
             end) =~ "Usage:"
    end

    test "--help option prints the help documentation" do
      assert capture_io(fn ->
               CLI.run(["--help"])
             end) =~ "Usage:"
    end
  end
end
