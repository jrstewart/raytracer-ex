defmodule Raytracer do
  alias Raytracer.CLI

  def main(argv) do
    case CLI.run(argv) do
      :ok -> System.halt(0)
      :error -> System.halt(2)
    end
  end
end
