defmodule Raytracer.Point2 do
  defstruct [
    x: 0.0,
    y: 0.0,
  ]

  @type t :: %__MODULE__{x: float, y: float}
end
