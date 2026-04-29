# Run-off check across all diagonals

Compares each diagonal's lower-tail cumulative ultimate against the main
diagonal's. Returns the run-off differences in chronological order.

## Usage

``` r
create_run_off_check(cum_trg)
```

## Arguments

- cum_trg:

  A cumulative numeric triangle.

## Value

Numeric vector of run-off differences with `length = nrow(cum_trg) - 1`.
