# Volume-weighted CHL factors with an explicit weight triangle

Same idea as
[`create_chl_coefs()`](https://donvito.github.io/vitopack/reference/create_chl_coefs.md)
but every cell is weighted by an arbitrary `trg_weight` matrix evaluated
at the **previous** column (`j - 1`). Useful when the natural exposure
differs from the cumulative triangle itself (e.g. paid claims weighted
by exposure-as-of-prior-period).

## Usage

``` r
create_chl_coefs_weighted(cum_trg, trg_weight, chl_length = "full")
```

## Arguments

- cum_trg:

  Cumulative triangle.

- trg_weight:

  Weight matrix of the same shape as `cum_trg`.

- chl_length:

  As in
  [`create_chl_coefs()`](https://donvito.github.io/vitopack/reference/create_chl_coefs.md).

## Value

A `data.frame` analogous to the output of
[`create_chl_coefs()`](https://donvito.github.io/vitopack/reference/create_chl_coefs.md).
