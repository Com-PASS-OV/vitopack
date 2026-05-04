# PVZP-style plotly visualisation (string x-axis)

Like
[`create_chl_trg_visualization()`](https://donvito.github.io/vitopack/reference/create_chl_trg_visualization.md),
but the x-axis is left as the raw character row names (no coercion to
numeric).

## Usage

``` r
create_chl_trg_visualization_pvzp(data_matrix, columns)
```

## Arguments

- data_matrix:

  A named matrix where row names act as the x-axis.

- columns:

  Character or numeric vector – which columns to plot.

## Value

A `plotly` htmlwidget.
