defmodule Raytracer.CLI do
  @moduledoc """
  Command line interface functions for the Raytracer program.
  """

  @doc """
  Runs the Raytracer program with given arguments.
  """
  @spec run(term) :: term
  def run(argv) do
    argv |> parse_args |> process
  end

  defp parse_args(argv) do
    argv
    |> OptionParser.parse(switches: [help: :boolean], aliases: [h: :help])
    |> case do
         {[help: true], _, _} -> :help
         _ -> :help
       end
  end

  defp process(:help) do
    IO.puts("""
    usage:  COMING SOON!!!
    """)

    :ok
  end
end
