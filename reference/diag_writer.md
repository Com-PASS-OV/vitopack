# Append the latest diagonal of a new triangle to an old one

Used in rolling re-runs: pads `old_trg` with one extra row and column of
`NA`, then fills in the gaps from `new_trg` (which already contains the
newly observed diagonal).

## Usage

``` r
diag_writer(old_trg, new_trg)
```

## Arguments

- old_trg:

  A `(n) x (n)` matrix - the old triangle.

- new_trg:

  A `(n+1) x (n+1)` matrix - the new triangle including the freshly
  observed diagonal.

## Value

The merged `(n+1) x (n+1)` matrix.

## Examples

``` r
old <- matrix(c(10, 5, 20, NA), nrow = 2, byrow = TRUE)
new <- matrix(c(10, 5, 3, 20, 6, NA, 25, NA, NA), nrow = 3, byrow = TRUE)
diag_writer(old, new)
#>      [,1] [,2] [,3]
#> [1,]   10    5    3
#> [2,]   20    6   NA
#> [3,]   25   NA   NA
```
