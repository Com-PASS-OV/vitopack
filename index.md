# vitopack

`vitopack` is a small toolbox of utilities that grew out of day-to-day
non-life actuarial work at **Com-PASS Advisory s.r.o.** It collects:

- Builders and transformations for chain-ladder development triangles
  (cumulative, decumulative, run-off, development factors with optional
  weighting, annual aggregation, plotly visualisation).
- Helpers that turn long policy data into per-period exposure columns
  ([`create_policy_exposure_columns_m()`](https://donvito.github.io/vitopack/reference/create_policy_exposure_columns_m.md),
  [`create_policy_exposure_days_columns()`](https://donvito.github.io/vitopack/reference/create_policy_exposure_days_columns.md)).
- Czech birth-number (*rodné číslo*) parsers.
- Smooth RGB rainbow palette generators tuned for stacked bars.
- Convenience I/O wrappers for multi-sheet `.xlsx` and `.xlsb` files.

## Installation

The development version from GitHub:

``` r
# install.packages("pak")
pak::pak("donvito/vitopack")
```

Once on CRAN:

``` r
install.packages("vitopack")
```

## Quick example

``` r
library(vitopack)

# Long-form claims data → triangle
df <- data.frame(
  origin = c(1, 1, 1, 2, 2, 3),
  dev    = c(0, 1, 2, 0, 1, 0),
  paid   = c(10, 5, 2, 20, 7, 15)
)
trg <- create_triangle(df, row_num = "origin", col_num = "dev", value = "paid")
cum <- create_cumulative_triangle(trg)
create_chl_coefs(cum, chl_length = c("full", 2))

# Czech birth number → date
rc_to_birth_day("900615/1234")  # 1990-06-15

# Smooth color palette
palette <- get_colors_duo(rgb_colors_for_plot(), 12)
```

## Contributing

Issues and pull requests are welcome. Please run `devtools::check()` and
`devtools::test()` before opening a PR.

## License

MIT © Ondřej Vít
