# Plotly visualisation of selected columns of a CHL triangle

Creates an interactive `plotly` line+marker chart of the selected
columns of `data_matrix`, with the row names used as the time axis.

## Usage

``` r
create_chl_trg_visualization(data_matrix, columns)
```

## Arguments

- data_matrix:

  A named matrix where row names act as the x-axis.

- columns:

  Character or numeric vector – which columns to plot.

## Value

A `plotly` htmlwidget.

## Examples

``` r
if (FALSE) { # \dontrun{
  trg <- matrix(c(1, 1.2, 1.05, 1, 1.3, NA, 1, NA, NA), 3,
                dimnames = list(c("2022", "2023", "2024"), c("0", "1", "2")))
  create_chl_trg_visualization(trg, columns = c("1", "2"))
} # }
```
