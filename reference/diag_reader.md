# Read values along a triangle diagonal

Returns the values along the `diag_num`-th anti-diagonal of `trg`,
starting from the bottom-left.

## Usage

``` r
diag_reader(trg, diag_num = nrow(trg))
```

## Arguments

- trg:

  A square numeric matrix (a triangle).

- diag_num:

  Integer - which anti-diagonal to read. Defaults to the main (last)
  one.

## Value

A numeric vector with the values on that diagonal.

## Examples

``` r
trg <- matrix(1:9, nrow = 3)
diag_reader(trg)
#> [1] 3 5 7
diag_reader(trg, diag_num = 2)
#> [1] 2 4
```
