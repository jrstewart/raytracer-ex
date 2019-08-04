locals_without_parens = [
  assert_equal_within_delta: 2,
  assert_equal_within_delta: 3,
  such_that: 2
]

[
  inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"],
  line_length: 100,
  locals_without_parens: locals_without_parens
]
