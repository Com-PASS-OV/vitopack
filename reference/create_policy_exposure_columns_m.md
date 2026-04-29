# Build per-period exposure columns (in years)

For each requested exposure period `[start_months[i], end_months[i]]`
the function adds a column `exp_names[i]` to `data` containing the
overlap of that period with each row's policy span
`[start_policy_var, end_policy_var]`, expressed in **years** (days /
365).

## Usage

``` r
create_policy_exposure_columns_m(
  data,
  exp_names,
  start_months,
  end_months,
  start_policy_var,
  end_policy_var
)
```

## Arguments

- data:

  A data.frame or data.table.

- exp_names:

  Character vector with the names of the new exposure columns.

- start_months, end_months:

  Character vectors of period boundaries that can be coerced via
  [`base::as.Date()`](https://rdrr.io/r/base/as.Date.html). Same length
  as `exp_names`.

- start_policy_var, end_policy_var:

  Names of the columns holding the policy start and end dates.

## Value

The updated data.table (modified in place).

## Examples

``` r
dt <- data.frame(
  policy_start = as.Date(c("2024-01-15", "2024-06-01")),
  policy_end   = as.Date(c("2024-12-31", "2025-05-31"))
)
create_policy_exposure_columns_m(
  data            = dt,
  exp_names       = c("exp_2024_Q1", "exp_2024_Q2"),
  start_months    = c("2024-01-01", "2024-04-01"),
  end_months      = c("2024-03-31", "2024-06-30"),
  start_policy_var = "policy_start",
  end_policy_var   = "policy_end"
)
#>    policy_start policy_end exp_2024_Q1 exp_2024_Q2
#>          <Date>     <Date>       <num>       <num>
#> 1:   2024-01-15 2024-12-31   0.2109589  0.24931507
#> 2:   2024-06-01 2025-05-31   0.0000000  0.08219178
```
