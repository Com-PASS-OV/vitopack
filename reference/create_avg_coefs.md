# Average development factors from a CHL factor triangle

Averages the per-cell development factors of a CHL factor triangle along
diagonals. For each requested window length, returns one row with the
simple-average factor per development period.

## Usage

``` r
create_avg_coefs(chl_trg, avg_length = "full")
```

## Arguments

- chl_trg:

  A development-factor triangle (e.g. the output of
  [`create_chl_coef_triangle()`](https://donvito.github.io/vitopack/reference/create_chl_coef_triangle.md)).

- avg_length:

  Vector – each element either `"full"` (use the full diagonal) or an
  integer giving the window length.

## Value

A `data.frame` with one row per `avg_length` element.
