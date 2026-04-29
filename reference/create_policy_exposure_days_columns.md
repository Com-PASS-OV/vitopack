# Build per-period exposure columns (in days)

Sister of
[`create_policy_exposure_columns_m()`](https://donvito.github.io/vitopack/reference/create_policy_exposure_columns_m.md)
— same logic, but the exposure is expressed in **days** (rounded)
instead of years.

## Usage

``` r
create_policy_exposure_days_columns(
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
  policy_start = as.Date("2024-01-15"),
  policy_end   = as.Date("2024-12-31")
)
create_policy_exposure_days_columns(
  data            = dt,
  exp_names       = "exp_days_q1",
  start_months    = "2024-01-01",
  end_months      = "2024-03-31",
  start_policy_var = "policy_start",
  end_policy_var   = "policy_end"
)
#>    policy_start policy_end exp_days_q1
#>          <Date>     <Date>       <num>
#> 1:   2024-01-15 2024-12-31          77
```
