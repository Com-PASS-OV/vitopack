#' Add zero/value columns based on equality conditions
#'
#' For each pair `(condition_names[i], new_cols_names[i])` the function adds a
#' new column to `data` initialised to `0`. Where the row matches
#' `data[[condition_var]] == condition_names[i]`, the new column is set to the
#' value of `data[[values_var]]` (evaluated as an expression — see Details).
#'
#' @details
#' The `values_var` argument is parsed and evaluated inside `data[, ...]`,
#' which means it can be a bare column name or a small data.table-style
#' expression. The function modifies `data` by reference (via
#' [data.table::setDT()]) and also returns it invisibly to allow chaining.
#'
#' @param data A data.frame or data.table.
#' @param condition_names Character vector of values to match against
#'   `condition_var`.
#' @param new_cols_names Character vector with the names of the new columns to
#'   create. Same length as `condition_names`.
#' @param condition_var Character scalar — name of the column to test.
#' @param values_var Character scalar — expression that yields the value to
#'   assign where the condition matches.
#'
#' @return The updated data.table (modified in place).
#' @export
#'
#' @examples
#' dt <- data.frame(line = c("MTPL", "CASCO", "MTPL"), premium = c(100, 200, 300))
#' create_find_columns(
#'   data = dt,
#'   condition_names = c("MTPL", "CASCO"),
#'   new_cols_names = c("MTPL_premium", "CASCO_premium"),
#'   condition_var = "line",
#'   values_var = "premium"
#' )
create_find_columns <- function(data, condition_names, new_cols_names,
                                condition_var, values_var) {
  data.table::setDT(data)
  for (i in seq_along(condition_names)) {
    data[, (new_cols_names[i]) := 0]
    data[eval(parse(text = paste0(condition_var, "=='", condition_names[i], "'"))),
         (new_cols_names[i]) := eval(parse(text = values_var))]
  }
  return(data)
}


#' Build per-period exposure columns (in years)
#'
#' For each requested exposure period `[start_months[i], end_months[i]]`
#' the function adds a column `exp_names[i]` to `data` containing the
#' overlap of that period with each row's policy span
#' `[start_policy_var, end_policy_var]`, expressed in **years**
#' (days / 365).
#'
#' @param data A data.frame or data.table.
#' @param exp_names Character vector with the names of the new exposure
#'   columns.
#' @param start_months,end_months Character vectors of period boundaries that
#'   can be coerced via [base::as.Date()]. Same length as `exp_names`.
#' @param start_policy_var,end_policy_var Names of the columns holding the
#'   policy start and end dates.
#'
#' @return The updated data.table (modified in place).
#' @export
#'
#' @examples
#' dt <- data.frame(
#'   policy_start = as.Date(c("2024-01-15", "2024-06-01")),
#'   policy_end   = as.Date(c("2024-12-31", "2025-05-31"))
#' )
#' create_policy_exposure_columns_m(
#'   data            = dt,
#'   exp_names       = c("exp_2024_Q1", "exp_2024_Q2"),
#'   start_months    = c("2024-01-01", "2024-04-01"),
#'   end_months      = c("2024-03-31", "2024-06-30"),
#'   start_policy_var = "policy_start",
#'   end_policy_var   = "policy_end"
#' )
create_policy_exposure_columns_m <- function(data, exp_names, start_months,
                                             end_months, start_policy_var,
                                             end_policy_var) {
  data.table::setDT(data)

  data[, (start_policy_var) := as.Date(get(start_policy_var))]
  data[, (end_policy_var)   := as.Date(get(end_policy_var))]

  for (i in seq_along(exp_names)) {
    data[, (exp_names[i]) := {
      sd <- as.Date(start_months[i])
      ed <- as.Date(end_months[i])

      sd_adj <- pmax(sd, get(start_policy_var))
      ed_adj <- pmin(ed, get(end_policy_var))
      days_diff  <- as.numeric(ed_adj - sd_adj) + 1
      years_diff <- ifelse(days_diff > 0, days_diff / 365, 0)
      years_diff
    }]
  }
  return(data)
}


#' Build per-period exposure columns (in days)
#'
#' Sister of [create_policy_exposure_columns_m()] — same logic, but the
#' exposure is expressed in **days** (rounded) instead of years.
#'
#' @inheritParams create_policy_exposure_columns_m
#'
#' @return The updated data.table (modified in place).
#' @export
#'
#' @examples
#' dt <- data.frame(
#'   policy_start = as.Date("2024-01-15"),
#'   policy_end   = as.Date("2024-12-31")
#' )
#' create_policy_exposure_days_columns(
#'   data            = dt,
#'   exp_names       = "exp_days_q1",
#'   start_months    = "2024-01-01",
#'   end_months      = "2024-03-31",
#'   start_policy_var = "policy_start",
#'   end_policy_var   = "policy_end"
#' )
create_policy_exposure_days_columns <- function(data, exp_names, start_months,
                                                end_months, start_policy_var,
                                                end_policy_var) {
  data.table::setDT(data)

  data[, (start_policy_var) := as.Date(get(start_policy_var))]
  data[, (end_policy_var)   := as.Date(get(end_policy_var))]

  for (i in seq_along(exp_names)) {
    data[, (exp_names[i]) := {
      sd <- as.Date(start_months[i])
      ed <- as.Date(end_months[i])

      sd_adj <- pmax(sd, get(start_policy_var))
      ed_adj <- pmin(ed, get(end_policy_var))
      days_diff  <- as.numeric(ed_adj - sd_adj) + 1
      years_diff <- round(ifelse(days_diff > 0, days_diff, 0))
      years_diff
    }]
  }
  return(data)
}


#' Multiply a set of columns by another column
#'
#' For each `multiple_exp_names[i]` the function creates a new column
#' `new_variable_names[i]` equal to `multiple_exp_names[i] * multiply_var`.
#'
#' @param data A data frame.
#' @param new_variable_names Character vector — names of the resulting
#'   columns.
#' @param multiple_exp_names Character vector — names of the columns to
#'   multiply.
#' @param multiply_var Character scalar — name of the multiplier column.
#'
#' @return A data frame with the new multiplied columns added.
#' @export
#'
#' @examples
#' df <- data.frame(exp_q1 = c(0.25, 0.5), exp_q2 = c(0.5, 0.5), premium = c(100, 200))
#' create_multiple_columns_m(
#'   data               = df,
#'   new_variable_names = c("prem_q1", "prem_q2"),
#'   multiple_exp_names = c("exp_q1", "exp_q2"),
#'   multiply_var       = "premium"
#' )
create_multiple_columns_m <- function(data, new_variable_names,
                                      multiple_exp_names, multiply_var) {
  data <- dplyr::mutate(
    data,
    dplyr::across(
      .cols  = tidyselect::all_of(multiple_exp_names),
      .fns   = ~ .x * !!rlang::sym(multiply_var),
      .names = "{.col}_kometa_brno"
    )
  )
  data <- dplyr::rename_with(
    data,
    .fn   = function(x) new_variable_names,
    .cols = tidyselect::ends_with("_kometa_brno")
  )
  return(data)
}


#' Row-bind a list of data frames with a `source` column
#'
#' Thin wrapper around [data.table::rbindlist()] that prepends a column called
#' `source` with the names of `lst`. Returns `NULL` for an empty input.
#'
#' @param lst A named list of data frames to bind together.
#'
#' @return A `data.table` with all columns from the inputs and an added
#'   `source` column, or `NULL` if `lst` is empty.
#' @export
#'
#' @examples
#' bind_with_source(list(
#'   a = data.frame(x = 1:2, y = 3:4),
#'   b = data.frame(x = 5,   z = 9)
#' ))
bind_with_source <- function(lst) {
  if (length(lst) == 0) return(NULL)
  data.table::rbindlist(lst, idcol = "source", use.names = TRUE, fill = TRUE)
}
