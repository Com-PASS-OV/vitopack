# Cumulative product of chain-ladder factors (ultimate development)

Given a one-row data frame of development factors as returned by
[`create_chl_coefs()`](https://donvito.github.io/vitopack/reference/create_chl_coefs.md),
computes the cumulative product from each development period to the
tail.

## Usage

``` r
create_product_coefs(chl_coefs, name = "Product")
```

## Arguments

- chl_coefs:

  A one-row data frame whose first column is a label and whose other
  columns hold development factors. (As returned by
  [`create_chl_coefs()`](https://donvito.github.io/vitopack/reference/create_chl_coefs.md).)

- name:

  Character – label for the resulting row.

## Value

A character vector of cumulative-product factors with `name` as the
first element.
