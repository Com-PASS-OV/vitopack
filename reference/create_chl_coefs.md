# Volume-weighted chain-ladder development factors

Computes one row of development factors per requested length (`"full"`
or an integer giving how many of the most recent rows to use). Factors
are aggregated using the standard volume-weighted formula
`sum(cum[, j]) / sum(cum[, j - 1])`.

## Usage

``` r
create_chl_coefs(cum_trg, chl_length = "full")
```

## Arguments

- cum_trg:

  A cumulative numeric triangle.

- chl_length:

  A vector — each element is either the literal `"full"` (use all rows)
  or a numeric/integer giving the window length. Default `"full"`.

## Value

A `data.frame` with one row per `chl_length` element, the first column
labelling the row and the remaining columns holding the development
factors.

## Examples

``` r
cum <- matrix(c(10, 30, 32,  20, 27, NA,  15, NA, NA), nrow = 3, byrow = TRUE)
create_chl_coefs(cum, chl_length = c("full", 2))
#>          CH_L_lengths  0   1        2
#> 1 chain_ladder - full NA 1.9 1.066667
#> 2    chain_ladder - 2 NA 1.9 1.066667
```
