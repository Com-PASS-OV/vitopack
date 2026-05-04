# Build a development triangle from row-level claims data

Aggregates `value` over `(row_num, col_num)` (optionally after filtering
by one or more `cond_variable == cond_value` pairs) and arranges the
result into a square `rows x rows` matrix where the upper-right corner
beyond the main anti-diagonal is `NA`.

## Usage

``` r
create_triangle(
  data,
  row_num,
  col_num,
  value,
  cond_variable = NULL,
  cond_value = NULL,
  rows = NULL
)
```

## Arguments

- data:

  A data frame (or tibble) with at least the columns named by `row_num`,
  `col_num` and `value`.

- row_num:

  Character - name of the column with row indices (origin periods,
  1-based).

- col_num:

  Character - name of the column with column indices (development
  periods, 0-based).

- value:

  Character - name of the numeric column to be summed.

- cond_variable:

  Optional character vector - names of columns to filter on.

- cond_value:

  Optional vector of values, same length as `cond_variable` - equality
  filter applied pairwise.

- rows:

  Optional integer - size of the output triangle. Defaults to the
  maximum value of `data[[row_num]]`.

## Value

A numeric `rows x rows` matrix.

## Examples

``` r
df <- expand.grid(origin = 1:3, dev = 0:2)
df$paid <- c(100, 50, 20,  120, 40, NA,  130, NA, NA)
df <- df[!is.na(df$paid), ]
create_triangle(df, row_num = "origin", col_num = "dev", value = "paid")
#>      [,1] [,2] [,3]
#> [1,]  100  120  130
#> [2,]   50   40   NA
#> [3,]   20   NA   NA
```
