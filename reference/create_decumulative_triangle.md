# De-cumulate a cumulative development triangle

Inverse of
[`create_cumulative_triangle()`](https://donvito.github.io/vitopack/reference/create_cumulative_triangle.md).

## Usage

``` r
create_decumulative_triangle(trg)
```

## Arguments

- trg:

  A cumulative triangle.

## Value

The incremental triangle.

## Examples

``` r
cum_trg <- matrix(c(10, 30, 32,  20, 27, NA,  15, NA, NA), nrow = 3, byrow = TRUE)
create_decumulative_triangle(cum_trg)
#>      [,1] [,2] [,3]
#> [1,]   10   20    2
#> [2,]   20    7   NA
#> [3,]   15   NA   NA
```
