defmodule Raytracer.MaterialTest do
  use ExUnit.Case, async: true
  alias Raytracer.Material

  @delta 1.0e-7

  describe "index_of_refraction/1" do
    test "returns 0.0 if the material does not have any normal reflectances" do
      material = %Material{normal_reflectances: []}
      assert Material.index_of_refraction(material) == 0.0
    end

    test "returns the computed index of refraction" do
      material = %Material{normal_reflectances: [0.5, 0.25, 0.1]}
      assert_in_delta Material.index_of_refraction(material), 3.58445923, @delta
    end
  end

  describe "parse/1" do
    test "parses the material data from the given map" do
      data = %{
        "diffuse" => 0.6,
        "specular" => 0.4,
        "shininess" => 0.2,
        "reflected_scale_factor" => 0.8,
        "transmitted_scale_factor" => 0.1,
        "normal_reflectances" => [
          0.460,
          0.420,
          0.410,
          0.350,
          0.180,
          0.080,
          0.050
        ]
      }

      assert {:ok, material} = Material.parse(data)
      assert material.diffuse == 0.6
      assert material.specular == 0.4
      assert material.shininess == 0.2
      assert material.reflected_scale_factor == 0.8
      assert material.transmitted_scale_factor == 0.1

      assert material.normal_reflectances == [
               0.460,
               0.420,
               0.410,
               0.350,
               0.180,
               0.080,
               0.050
             ]
    end

    test "returns an error if parsing failed" do
      data = %{"diffuse" => 0.6}
      assert {:error, message} = Material.parse(data)
      assert message == "error parsing material"
    end
  end
end
