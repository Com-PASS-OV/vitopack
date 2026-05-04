# Re-aggregate a per-period triangle to an annual triangle

Combines `period` consecutive sub-period diagonals/columns of a
cumulative triangle into one annual diagonal/column. Useful when the
source data is monthly or quarterly and the report wants annual figures.

## Usage

``` r
create_annual_triangle(cum_trg, period = 4)
```

## Arguments

- cum_trg:

  A cumulative numeric triangle.

- period:

  Integer - number of sub-periods that make up one year (default `4` for
  quarters).

## Value

A cumulative annual triangle (numeric matrix).

## Examples

``` r
# 4x4 quarterly cumulative triangle (only the lower-left corner is real data)
q_trg <- matrix(NA_real_, 4, 4)
q_trg[1, ] <- c(1, 2, 3, 4)
q_trg[2, 1:3] <- c(2, 4, 5)
q_trg[3, 1:2] <- c(3, 5)
q_trg[4, 1]   <- 4
create_annual_triangle(q_trg, period = 4)
#>      [,1]
#> [1,]   18
```
