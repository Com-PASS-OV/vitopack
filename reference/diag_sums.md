# Cumulative diagonal sums of a triangle

For each anti-diagonal `k = 1..nrow(trg)` returns the sum of its values.

## Usage

``` r
diag_sums(trg)
```

## Arguments

- trg:

  A square numeric matrix (a triangle).

## Value

Numeric vector of length `nrow(trg)`.

## Examples

``` r
diag_sums(matrix(c(10, 5, 2,  20, 7, NA,  15, NA, NA), nrow = 3, byrow = TRUE))
#> [1] 10 25 24
```
