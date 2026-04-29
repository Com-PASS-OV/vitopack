# Rename a triangle's rows/columns for printing

Replaces the column names with `0..ncol-1` (development periods) and
sets the row names to `claim_period_names[1:nrow(trg)]` (origin
periods).

## Usage

``` r
triangle_namer(trg, claim_period_names)
```

## Arguments

- trg:

  A square numeric matrix.

- claim_period_names:

  Character vector of origin-period labels (must be at least `nrow(trg)`
  long).

## Value

The same matrix with `dimnames` set.

## Examples

``` r
trg <- matrix(1:9, 3, 3)
triangle_namer(trg, c("2022", "2023", "2024"))
#>      0 1 2
#> 2022 1 4 7
#> 2023 2 5 8
#> 2024 3 6 9
```
