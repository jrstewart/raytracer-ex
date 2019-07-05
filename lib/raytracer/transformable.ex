defprotocol Raytracer.Transformable do
  @moduledoc """
  A protocol that defines an interface for working with items that can have a transform applied to
  them.
  """

  alias Raytracer.Transform

  @doc """
  Applies `transform` to `transformable` and returns the result.
  """
  @spec apply_transform(t, Transform.t()) :: t
  def apply_transform(transformable, transform)
end
