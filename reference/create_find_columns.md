# Add zero/value columns based on equality conditions

For each pair `(condition_names[i], new_cols_names[i])` the function
adds a new column to `data` initialised to `0`. Where the row matches
`data[[condition_var]] == condition_names[i]`, the new column is set to
the value of `data[[values_var]]` (evaluated as an expression - see
Details).

## Usage

``` r
create_find_columns(
  data,
  condition_names,
  new_cols_names,
  condition_var,
  values_var
)
```

## Arguments

- data:

  A data.frame or data.table.

- condition_names:

  Character vector of values to match against `condition_var`.

- new_cols_names:

  Character vector with the names of the new columns to create. Same
  length as `condition_names`.

- condition_var:

  Character scalar - name of the column to test.

- values_var:

  Character scalar - expression that yields the value to assign where
  the condition matches.

## Value

The updated data.table (modified in place).

## Details

The `values_var` argument is parsed and evaluated inside `data[, ...]`,
which means it can be a bare column name or a small data.table-style
expression. The function modifies `data` by reference (via
[`data.table::setDT()`](https://rdrr.io/pkg/data.table/man/setDT.html))
and also returns it invisibly to allow chaining.

## Examples

``` r
dt <- data.frame(line = c("MTPL", "CASCO", "MTPL"), premium = c(100, 200, 300))
create_find_columns(
  data = dt,
  condition_names = c("MTPL", "CASCO"),
  new_cols_names = c("MTPL_premium", "CASCO_premium"),
  condition_var = "line",
  values_var = "premium"
)
#> Index: <line>
#>      line premium MTPL_premium CASCO_premium
#>    <char>   <num>        <num>         <num>
#> 1:   MTPL     100          100             0
#> 2:  CASCO     200            0           200
#> 3:   MTPL     300          300             0
```
