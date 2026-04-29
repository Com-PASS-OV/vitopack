# Pick `n` evenly spaced colors from a rainbow data frame

Three flavours are exported. They differ only in the post-processing
they apply after picking equally-spaced rows from `rgb_df`:

## Usage

``` r
get_colors(rgb_df, n_colors)

get_colors_plus(rgb_df, n_colors)

get_colors_duo(rgb_df, n_colors)
```

## Arguments

- rgb_df:

  A data frame with columns `r`, `g`, `b`, e.g. produced by
  [`rgb_colors_for_plot()`](https://donvito.github.io/vitopack/reference/rgb_colors_for_plot.md).

- n_colors:

  Integer \>= 2 – number of colors to return.

## Value

A character vector of length `n_colors` with hex color codes
(`"#RRGGBB"`).

## Details

- `get_colors()` – no post-processing.

- `get_colors_plus()` – every other color is darkened (x0.75) or
  lightened (towards 255 with weight 0.7), creating a strong duo
  pattern.

- `get_colors_duo()` – every other color is darkened (x0.8) or lightened
  (weight 0.6), milder than the `_plus` variant.

## Examples

``` r
rgb_df <- rgb_colors_for_plot()
get_colors(rgb_df, 5)
#> [1] "#00FF00" "#00BFFF" "#7F00FF" "#FF0040" "#FFFF00"
get_colors_plus(rgb_df, 6)
#> [1] "#00FF00" "#B2FFFF" "#0000FF" "#BF00BF" "#FF0000" "#FFFFB2"
get_colors_duo(rgb_df, 6)
#> [1] "#99FF99" "#00CCCC" "#9999FF" "#CC00CC" "#FF9999" "#CCCC00"
```
