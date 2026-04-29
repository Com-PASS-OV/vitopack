# Format a number with a thin space as the thousands separator

Convenience wrapper around
[`base::format()`](https://rdrr.io/r/base/format.html) with sensible
Czech-friendly defaults (thin space as group separator, `.` as decimal
mark, no scientific notation).

## Usage

``` r
numeric_format(number)
```

## Arguments

- number:

  Numeric vector.

## Value

A character vector of formatted numbers.

## Examples

``` r
numeric_format(c(1234567, 89.5))
#> [1] "1 234 567.0" "       89.5"
```
