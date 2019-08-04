defmodule Raytracer.Parser do
  @moduledoc """
  This module defines functions and a behaviour for parsing data from a map.
  """

  @callback parse(map()) :: {:ok, term()} | {:error, String.t()}
end
