# Element-wise chain-ladder development factor triangle

For every cell `(i, j)` of a cumulative triangle returns
`cum_trg[i, j] / cum_trg[i, j-1]`. The first column and the upper-right
`NA` corner are left as `NA`.

## Usage

``` r
create_chl_coef_triangle(cum_trg)
```

## Arguments

- cum_trg:

  A cumulative numeric triangle.

## Value

A numeric matrix of the same shape with development factors.

## Examples

``` r
cum <- matrix(c(10, 30, 32,  20, 27, NA,  15, NA, NA), nrow = 3, byrow = TRUE)
create_chl_coef_triangle(cum)
#>      [,1] [,2]     [,3]
#> [1,]   NA 3.00 1.066667
#> [2,]   NA 1.35       NA
#> [3,]   NA   NA       NA
```
