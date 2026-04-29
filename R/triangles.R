#' Build a development triangle from row-level claims data
#'
#' Aggregates `value` over `(row_num, col_num)` (optionally after filtering
#' by one or more `cond_variable == cond_value` pairs) and arranges the
#' result into a square `rows x rows` matrix where the upper-right corner
#' beyond the main anti-diagonal is `NA`.
#'
#' @param data A data frame (or tibble) with at least the columns named by
#'   `row_num`, `col_num` and `value`.
#' @param row_num Character - name of the column with row indices (origin
#'   periods, 1-based).
#' @param col_num Character - name of the column with column indices
#'   (development periods, 0-based).
#' @param value Character - name of the numeric column to be summed.
#' @param cond_variable Optional character vector - names of columns to
#'   filter on.
#' @param cond_value Optional vector of values, same length as
#'   `cond_variable` - equality filter applied pairwise.
#' @param rows Optional integer - size of the output triangle. Defaults to
#'   the maximum value of `data[[row_num]]`.
#'
#' @return A numeric `rows x rows` matrix.
#' @export
#'
#' @examples
#' df <- expand.grid(origin = 1:3, dev = 0:2)
#' df$paid <- c(100, 50, 20,  120, 40, NA,  130, NA, NA)
#' df <- df[!is.na(df$paid), ]
#' create_triangle(df, row_num = "origin", col_num = "dev", value = "paid")
create_triangle <- function(data, row_num, col_num, value,
                            cond_variable = NULL, cond_value = NULL,
                            rows = NULL) {
  if (is.null(rows)) {
    rows <- max(data[[row_num]], na.rm = TRUE)
  }

  if (length(cond_variable) > 0) {
    for (c in seq_along(cond_variable)) {
      data <- dplyr::filter(data, !!rlang::sym(cond_variable[c]) == cond_value[c])
    }
  }
  trg_matrix <- matrix(NA_real_, nrow = rows, ncol = rows)
  temp_data <- dplyr::summarise(
    dplyr::group_by(data, !!rlang::sym(row_num), !!rlang::sym(col_num)),
    value = sum(!!rlang::sym(value)),
    .groups = "drop"
  )
  for (i in seq_len(rows)) {
    for (j in 0:rows) {
      if (i + j > rows + 1) next
      act_val <- dplyr::pull(
        dplyr::filter(temp_data,
                      !!rlang::sym(row_num) == i,
                      !!rlang::sym(col_num) == j - 1),
        value
      )
      act_val <- ifelse(length(act_val) == 0, 0, act_val)
      trg_matrix[i, j] <- act_val
    }
  }
  return(trg_matrix)
}


#' Cumulate a development triangle along columns
#'
#' Turns an incremental triangle into a cumulative one by running cumulative
#' sums along the rows (development direction).
#'
#' @param trg An incremental triangle (numeric matrix) where the upper-right
#'   `NA` corner is preserved.
#'
#' @return A numeric matrix of the same shape, cumulatively summed.
#' @export
#'
#' @examples
#' trg <- matrix(c(10, 5, 2,  20, 7, NA,  15, NA, NA), nrow = 3, byrow = TRUE)
#' create_cumulative_triangle(trg)
create_cumulative_triangle <- function(trg) {
  rows <- nrow(trg)
  for (j in seq_len(rows)) {
    for (i in seq_len(rows)) {
      if (i + j > rows + 1 || j == 1) next
      trg[i, j] <- trg[i, j] + trg[i, (j - 1)]
    }
  }
  return(trg)
}


#' De-cumulate a cumulative development triangle
#'
#' Inverse of [create_cumulative_triangle()].
#'
#' @param trg A cumulative triangle.
#'
#' @return The incremental triangle.
#' @export
#'
#' @examples
#' cum_trg <- matrix(c(10, 30, 32,  20, 27, NA,  15, NA, NA), nrow = 3, byrow = TRUE)
#' create_decumulative_triangle(cum_trg)
create_decumulative_triangle <- function(trg) {
  rows <- nrow(trg)
  for (j in rows:1) {
    for (i in rows:1) {
      if (i + j > rows + 1 || j == 1) next
      trg[i, j] <- trg[i, j] - trg[i, (j - 1)]
    }
  }
  return(trg)
}


#' Read values along a triangle diagonal
#'
#' Returns the values along the `diag_num`-th anti-diagonal of `trg`,
#' starting from the bottom-left.
#'
#' @param trg A square numeric matrix (a triangle).
#' @param diag_num Integer - which anti-diagonal to read. Defaults to the
#'   main (last) one.
#'
#' @return A numeric vector with the values on that diagonal.
#' @export
#'
#' @examples
#' trg <- matrix(1:9, nrow = 3)
#' diag_reader(trg)
#' diag_reader(trg, diag_num = 2)
diag_reader <- function(trg, diag_num = nrow(trg)) {
  i <- diag_num
  j <- 1
  values <- numeric()
  while (i > 0) {
    values <- c(values, trg[i, j])
    i <- i - 1
    j <- j + 1
  }
  return(values)
}


#' Cumulative diagonal sums of a triangle
#'
#' For each anti-diagonal `k = 1..nrow(trg)` returns the sum of its values.
#'
#' @param trg A square numeric matrix (a triangle).
#'
#' @return Numeric vector of length `nrow(trg)`.
#' @export
#'
#' @examples
#' diag_sums(matrix(c(10, 5, 2,  20, 7, NA,  15, NA, NA), nrow = 3, byrow = TRUE))
diag_sums <- function(trg) {
  diag_sum <- numeric()
  for (i in seq_len(nrow(trg))) {
    diag_sum[i] <- sum(diag_reader(trg, diag_num = i))
  }
  return(diag_sum)
}


#' Append the latest diagonal of a new triangle to an old one
#'
#' Used in rolling re-runs: pads `old_trg` with one extra row and column of
#' `NA`, then fills in the gaps from `new_trg` (which already contains the
#' newly observed diagonal).
#'
#' @param old_trg A `(n) x (n)` matrix - the old triangle.
#' @param new_trg A `(n+1) x (n+1)` matrix - the new triangle including the
#'   freshly observed diagonal.
#'
#' @return The merged `(n+1) x (n+1)` matrix.
#' @export
#'
#' @examples
#' old <- matrix(c(10, 5, 20, NA), nrow = 2, byrow = TRUE)
#' new <- matrix(c(10, 5, 3, 20, 6, NA, 25, NA, NA), nrow = 3, byrow = TRUE)
#' diag_writer(old, new)
diag_writer <- function(old_trg, new_trg) {
  old_trg <- rbind(old_trg, rep(NA, ncol(old_trg)))
  old_trg <- cbind(old_trg, rep(NA, nrow(old_trg)))
  matrix(
    dplyr::coalesce(as.vector(old_trg), as.vector(new_trg)),
    nrow  = nrow(new_trg),
    byrow = FALSE
  )
}


#' Re-aggregate a per-period triangle to an annual triangle
#'
#' Combines `period` consecutive sub-period diagonals/columns of a
#' cumulative triangle into one annual diagonal/column. Useful when the
#' source data is monthly or quarterly and the report wants annual figures.
#'
#' @param cum_trg A cumulative numeric triangle.
#' @param period Integer - number of sub-periods that make up one year
#'   (default `4` for quarters).
#'
#' @return A cumulative annual triangle (numeric matrix).
#' @export
#'
#' @examples
#' # 4x4 quarterly cumulative triangle (only the lower-left corner is real data)
#' q_trg <- matrix(NA_real_, 4, 4)
#' q_trg[1, ] <- c(1, 2, 3, 4)
#' q_trg[2, 1:3] <- c(2, 4, 5)
#' q_trg[3, 1:2] <- c(3, 5)
#' q_trg[4, 1]   <- 4
#' create_annual_triangle(q_trg, period = 4)
create_annual_triangle <- function(cum_trg, period = 4) {
  rows <- nrow(cum_trg)
  years <- floor(rows / period)
  trg <- matrix(NA_real_, ncol = years, nrow = years)
  diag_num <- rows
  for (d in years:1) {
    act_diag <- diag_reader(trg = cum_trg, diag_num = diag_num)
    diag_length <- floor(length(act_diag) / period)
    if (diag_length >= 1) {
      for (n_in_diag in seq_len(diag_length)) {
        trg[d - n_in_diag + 1, n_in_diag] <- sum(
          act_diag[((n_in_diag - 1) * period + 1):(n_in_diag * period)]
        )
      }
    }
    diag_num <- diag_num - period
  }
  return(trg)
}


#' Run-off check across all diagonals
#'
#' Compares each diagonal's lower-tail cumulative ultimate against the main
#' diagonal's. Returns the run-off differences in chronological order.
#'
#' @param cum_trg A cumulative numeric triangle.
#'
#' @return Numeric vector of run-off differences with `length =
#'   nrow(cum_trg) - 1`.
#' @export
create_run_off_check <- function(cum_trg) {
  main_diag <- diag_reader(cum_trg)
  run_offs  <- numeric()
  for (i in seq_len(nrow(cum_trg) - 1)) {
    second_diag <- diag_reader(trg = cum_trg, diag_num = nrow(cum_trg) - i)
    run_offs[i] <- sum(main_diag[(1 + i):length(main_diag)]) - sum(second_diag)
  }
  return(rev(run_offs))
}


#' Rename a triangle's rows/columns for printing
#'
#' Replaces the column names with `0..ncol-1` (development periods) and sets
#' the row names to `claim_period_names[1:nrow(trg)]` (origin periods).
#'
#' @param trg A square numeric matrix.
#' @param claim_period_names Character vector of origin-period labels (must
#'   be at least `nrow(trg)` long).
#'
#' @return The same matrix with `dimnames` set.
#' @export
#'
#' @examples
#' trg <- matrix(1:9, 3, 3)
#' triangle_namer(trg, c("2022", "2023", "2024"))
triangle_namer <- function(trg, claim_period_names) {
  claim_period_names_short <- claim_period_names[seq_len(nrow(trg))]
  colnames(trg) <- 0:(ncol(trg) - 1)
  rownames(trg) <- claim_period_names_short
  return(trg)
}
