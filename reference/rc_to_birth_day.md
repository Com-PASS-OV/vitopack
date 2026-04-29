# Convert a Czech birth number to a date of birth

These three variants implement slightly different rules for resolving
the century (the two-digit year stored in a Czech *rodné číslo*). They
are kept as separate functions so existing code that depends on a
particular rule keeps working.

## Usage

``` r
rc_to_birth_day(rc_s_lomitkem)

rc_to_birth_day_2(rc_s_lomitkem)

rc_to_birth_day_3(rc_s_lomitkem)
```

## Arguments

- rc_s_lomitkem:

  Character vector. Czech birth number, optionally with a `/` separating
  the suffix. The first six digits (YYMMDD) are what matters for the
  date.

## Value

A `Date` vector of the same length as `rc_s_lomitkem`.

## Details

- `rc_to_birth_day()` — assumes the input has the trailing 4-digit
  suffix separated by a slash (`"YYMMDD/XXXX"`, total length 11). Years
  `< 54` go into the 21st century, otherwise the 20th.

- `rc_to_birth_day_2()` — does not check length and uses cut-off `25` —
  anything `< 25` is 21st century, otherwise 20th.

- `rc_to_birth_day_3()` — like `rc_to_birth_day()` but with cut-off
  `25`.

All three apply the women-offset (+50 added to the month for women, so
months 51–62 → 01–12).

## Examples

``` r
rc_to_birth_day("905615/1234")     # man, 1990-06-15
#> [1] "1990-06-15"
rc_to_birth_day("9056151234")      # man, 1990-06-15  (no slash, length 10)
#> [1] "1990-06-15"
rc_to_birth_day_2("055615/1234")   # cut-off 25 → 2005-06-15
#> [1] "2005-06-15"
rc_to_birth_day_3("055615/1234")   # 11 chars + cut-off 25 → 2005-06-15
#> [1] "2005-06-15"
```
