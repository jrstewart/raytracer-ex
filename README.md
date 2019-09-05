# Raytracer

A physically-based graphics rendering engine written in Elixir.

## Project setup

### Building

Clone the repo and fetch its dependencies:

```
git clone https://github.com/jrstewart/raytracer_ex.git
cd raytracer_ex
mix deps.get
mix escript.build
```

### Running tests

After cloning the repo and fetch its dependencies run:

```
mix test
```


### Running Dialyzer

After cloning the repo, run the following:

```
mix dialyzer
```

## Usage

To build a scene specify scene, renderer, and output files to the `raytracer`
executable.

```
./raytracer -r renderer.json -s scene.json -o output.tga
```

To view information about all the available command line options run:

```
./raytracer -h
```

### Renderer file

The following is an example of the format for the renderer JSON file:

```json
{
  "camera": {
    "center": [0.0, 0.0, 0.0],
    "distance": 5.0,
    "eye": [0.0, 3.0, 15.0],
    "height": 1000,
    "width": 1000,
    "wc_window": [-2.0, 2.0, -2.0, 2.0],
    "up": [0.0, 1.0, 0.0]
  },
  "ambient_light_color": [0.1, 0.1, 0.1],
  "attenuation_cutoff": 0.01,
  "background_color": [0.0, 0.0, 0.0],
  "global_rgb_scale": 2.59,
  "max_recursive_depth": 4,
  "supersample_size": 0
}
```

### Scene file

The following is an example of the format for the scene JSON file:

```json
{
  "lights": [
    {
      "type": "directional",
      "color": [0.5, 0.5, 0.5],
      "data": {
        "direction": [1.0, 1.0, 0.0],
        "solid_angle": 1.0
      }
    },
    {
      "type": "positional",
      "color": [0.5, 0.5, 0.5],
      "data": {
        "position": [0.0, 3.0, 3.0],
        "radius": 1.0
      }
    }
  ],
  "models": [
    {
      "type": "sphere",
      "data": {
        "center": [0.0, 1.0, 0.0],
        "radius": 2.0
      },
      "material": {
        "diffuse": 0.6,
        "specular": 0.6,
        "shininess": 0.4,
        "reflected_scale_factor": 0.025,
        "transmitted_scale_factor": 0.0,
        "normal_reflectances": [0.460, 0.420, 0.410, 0.350, 0.180, 0.080, 0.050]
      }
    },
    {
      "type": "triangle",
      "data": {
        "vertices": [[-100.0, -2.0, -100.0], [100.0, -2.0, -100.0], [-100.0, -2.0, 100.0]],
        "normals": [[0.0, 1.0, 0.0], [0.0, 1.0, 0.0], [0.0, 1.0, 0.0]]
      },
      "material": {
        "diffuse": 0.8,
        "specular": 0.2,
        "shininess": 0.01,
        "reflected_scale_factor": 0.0,
        "transmitted_scale_factor": 0.0,
        "normal_reflectances": [0.2, 0.2, 0.2]
      }
    },
    {
      "type": "triangle",
      "data": {
        "vertices": [[-100.0, -2.0, 100.0], [100.0, -2.0, -100.0], [100.0, -2.0, 100.0]],
        "normals": [[0.0, 1.0, 0.0], [0.0, 1.0, 0.0], [0.0, 1.0, 0.0]]
      },
      "material": {
        "diffuse": 0.8,
        "specular": 0.2,
        "shininess": 0.01,
        "reflected_scale_factor": 0.0,
        "transmitted_scale_factor": 0.0,
        "normal_reflectances": [0.2, 0.2, 0.2]
      }
    }
  ]
}
```

### Global RGB scale

Occasionally when rendering a scene some color values computed in the scene will
be greater than maximum allowed red, green, or blue intensity values. This will
result in the image colors looking incorrect because the image format cannot
support color values greater than 255. To account for this an adjusted
`global_rgb_scale` value can be specified in the renderer JSON file.

This option can also be used if the scene appears too dark and none of the color
values exceed the maximum color intensity value.

To determine what value to use for the `global_rgb_scale` the `--suggest-scale`
flag can be provided when running the program and a suggested value will be
printed after rendering has completed.
