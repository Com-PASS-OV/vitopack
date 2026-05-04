# Getting started with vitopack

``` r

library(vitopack)
```

`vitopack` collects a handful of utilities for non-life actuarial work.
This vignette walks through the three most common use cases.

## 1. Building a chain-ladder triangle

Start from long claims data and aggregate into a triangle:

``` r

df <- data.frame(
  origin = c(1, 1, 1, 2, 2, 3),
  dev    = c(0, 1, 2, 0, 1, 0),
  paid   = c(10, 5, 2, 20, 7, 15)
)

trg <- create_triangle(df,
                       row_num = "origin",
                       col_num = "dev",
                       value   = "paid")
trg
#>      [,1] [,2] [,3]
#> [1,]   10    5    2
#> [2,]   20    7   NA
#> [3,]   15   NA   NA
```

Cumulate, then read off development factors:

``` r

cum <- create_cumulative_triangle(trg)
create_chl_coefs(cum, chl_length = c("full", 2))
#>          CH_L_lengths  0   1        2
#> 1 chain_ladder - full NA 1.4 1.133333
#> 2    chain_ladder - 2 NA 1.4 1.133333
```

A weighted variant accepts an explicit weight matrix (e.g. exposure):

``` r

weight <- matrix(1, nrow = nrow(cum), ncol = ncol(cum))
weight[is.na(cum)] <- NA
create_chl_coefs_weighted(cum, weight, chl_length = "full")
#>          CH_L_lengths  0     1        2
#> 1 chain_ladder - full NA 1.425 1.133333
```

For visual inspection use
[`create_chl_trg_visualization()`](https://donvito.github.io/vitopack/reference/create_chl_trg_visualization.md)
(requires the `plotly` package, listed as a *Suggests* dependency).

## 2. Per-period exposure columns

Turn a policy table into one column per accounting period:

``` r

policies <- data.frame(
  policy_start = as.Date(c("2024-01-15", "2024-06-01")),
  policy_end   = as.Date(c("2024-12-31", "2025-05-31"))
)

create_policy_exposure_columns_m(
  data             = policies,
  exp_names        = c("exp_q1", "exp_q2", "exp_q3", "exp_q4"),
  start_months     = c("2024-01-01", "2024-04-01", "2024-07-01", "2024-10-01"),
  end_months       = c("2024-03-31", "2024-06-30", "2024-09-30", "2024-12-31"),
  start_policy_var = "policy_start",
  end_policy_var   = "policy_end"
)
```

## 3. Czech birth numbers

Three slightly different rules for resolving the century are supported.

``` r

rc_to_birth_day("900615/1234")     # man, 1990-06-15
#> [1] "1990-06-15"
rc_to_birth_day("055615/1234")     # woman, 2005-06-15
#> [1] "2005-06-15"
rc_to_birth_day_2("240615/1234")   # cut-off 25 → 2024-06-15
#> [1] "2024-06-15"
```

## 4. Smooth color palettes for plots

``` r

rgb_df <- rgb_colors_for_plot()
get_colors_duo(rgb_df, 8)
#> [1] "#99FF99" "#00CC92" "#99D3FF" "#1C00CC" "#F099FF" "#CC0057" "#FFB599"
#> [8] "#CCCC00"
```

``` r

plot_color_bars(12)
```
