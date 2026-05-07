# Quick visual sanity check of a generated palette

Convenience wrapper that calls
[`rgb_colors_for_plot()`](https://donvito.github.io/vitopack/reference/rgb_colors_for_plot.md)
and
[`get_colors_duo()`](https://donvito.github.io/vitopack/reference/get_colors.md)
and renders the result as a stacked bar chart.

## Usage

``` r
plot_color_bars(n_colors)
```

## Arguments

- n_colors:

  Integer \>= 2 – number of palette stops to plot.

## Value

Invisible `NULL`. Called for the side effect of plotting.

## Examples

``` r
plot_color_bars(12)
```
