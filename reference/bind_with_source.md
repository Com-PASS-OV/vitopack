# Row-bind a list of data frames with a `source` column

Thin wrapper around
[`data.table::rbindlist()`](https://rdrr.io/pkg/data.table/man/rbindlist.html)
that prepends a column called `source` with the names of `lst`. Returns
`NULL` for an empty input.

## Usage

``` r
bind_with_source(lst)
```

## Arguments

- lst:

  A named list of data frames to bind together.

## Value

A `data.table` with all columns from the inputs and an added `source`
column, or `NULL` if `lst` is empty.

## Examples

``` r
bind_with_source(list(
  a = data.frame(x = 1:2, y = 3:4),
  b = data.frame(x = 5,   z = 9)
))
#>    source     x     y     z
#>    <char> <num> <int> <num>
#> 1:      a     1     3    NA
#> 2:      a     2     4    NA
#> 3:      b     5    NA     9
```
