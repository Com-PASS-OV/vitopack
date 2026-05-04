# Multiply a set of columns by another column

For each `multiple_exp_names[i]` the function creates a new column
`new_variable_names[i]` equal to `multiple_exp_names[i] * multiply_var`.

## Usage

``` r
create_multiple_columns_m(
  data,
  new_variable_names,
  multiple_exp_names,
  multiply_var
)
```

## Arguments

- data:

  A data frame.

- new_variable_names:

  Character vector - names of the resulting columns.

- multiple_exp_names:

  Character vector - names of the columns to multiply.

- multiply_var:

  Character scalar - name of the multiplier column.

## Value

A data frame with the new multiplied columns added.

## Examples

``` r
df <- data.frame(exp_q1 = c(0.25, 0.5), exp_q2 = c(0.5, 0.5), premium = c(100, 200))
create_multiple_columns_m(
  data               = df,
  new_variable_names = c("prem_q1", "prem_q2"),
  multiple_exp_names = c("exp_q1", "exp_q2"),
  multiply_var       = "premium"
)
#>   exp_q1 exp_q2 premium prem_q1 prem_q2
#> 1   0.25    0.5     100      25      50
#> 2   0.50    0.5     200     100     100
```
