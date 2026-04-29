# Build a smooth RGB rainbow data frame

Produces a tibble of `r`, `g`, `b` channel values walking through the
six canonical rainbow segments (red -\> yellow -\> green -\> cyan -\>
blue -\> purple -\> red). The argument selects which segments to include
and in which order.

## Usage

``` r
rgb_colors_for_plot(colors_changes_vector = c(3:6, 1))
```

## Arguments

- colors_changes_vector:

  Integer vector with values in `1:6`. Default `c(3:6, 1)` gives a green
  -\> red sweep.

## Value

A
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
with columns `r`, `g`, `b`.

## Examples

``` r
head(rgb_colors_for_plot())
#> # A tibble: 6 × 3
#>       r     g     b
#>   <dbl> <dbl> <dbl>
#> 1     0   255     0
#> 2     0   255     1
#> 3     0   255     2
#> 4     0   255     3
#> 5     0   255     4
#> 6     0   255     5
```
