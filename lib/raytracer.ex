defmodule Raytracer do
  @moduledoc """
  Top-level entry point for the Raytracer program.
  """

  alias Raytracer.CLI

  @spec main(term) :: no_return
  def main(argv) do
    case CLI.run(argv) do
      :ok -> System.halt(0)
    end
  end
end
