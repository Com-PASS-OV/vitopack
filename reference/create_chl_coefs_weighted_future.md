# Volume-weighted CHL factors with weight at the *current* column

Variant of
[`create_chl_coefs_weighted()`](https://donvito.github.io/vitopack/reference/create_chl_coefs_weighted.md)
that uses `trg_weight[, j]` instead of `trg_weight[, j - 1]`, i.e. the
weight evaluated at the developed (forward-looking) column.

## Usage

``` r
create_chl_coefs_weighted_future(cum_trg, trg_weight, chl_length = "full")
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
