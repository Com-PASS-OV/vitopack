# Cumulate a development triangle along columns

Turns an incremental triangle into a cumulative one by running
cumulative sums along the rows (development direction).

## Usage

``` r
create_cumulative_triangle(trg)
```

## Arguments

- trg:

  An incremental triangle (numeric matrix) where the upper-right `NA`
  corner is preserved.

## Value

A numeric matrix of the same shape, cumulatively summed.

## Examples

``` r
trg <- matrix(c(10, 5, 2,  20, 7, NA,  15, NA, NA), nrow = 3, byrow = TRUE)
create_cumulative_triangle(trg)
#>      [,1] [,2] [,3]
#> [1,]   10   15   17
#> [2,]   20   27   NA
#> [3,]   15   NA   NA
```
