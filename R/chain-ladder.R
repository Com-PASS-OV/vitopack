#' Element-wise chain-ladder development factor triangle
#'
#' For every cell `(i, j)` of a cumulative triangle returns
#' `cum_trg[i, j] / cum_trg[i, j-1]`. The first column and the upper-right
#' `NA` corner are left as `NA`.
#'
#' @param cum_trg A cumulative numeric triangle.
#'
#' @return A numeric matrix of the same shape with development factors.
#' @export
#'
#' @examples
#' cum <- matrix(c(10, 30, 32,  20, 27, NA,  15, NA, NA), nrow = 3, byrow = TRUE)
#' create_chl_coef_triangle(cum)
create_chl_coef_triangle <- function(cum_trg) {
  chl_trg <- matrix(NA_real_, nrow = nrow(cum_trg), ncol = ncol(cum_trg))
  rows <- nrow(cum_trg)
  for (i in seq_len(nrow(cum_trg))) {
    for (j in seq_len(ncol(cum_trg))) {
      if (i + j > rows + 1 || j == 1) next
      chl_trg[i, j] <- cum_trg[i, j] / cum_trg[i, j - 1]
    }
  }
  return(chl_trg)
}


#' Volume-weighted chain-ladder development factors
#'
#' Computes one row of development factors per requested length (`"full"` or
#' an integer giving how many of the most recent rows to use). Factors are
#' aggregated using the standard volume-weighted formula
#' `sum(cum[, j]) / sum(cum[, j - 1])`.
#'
#' @param cum_trg A cumulative numeric triangle.
#' @param chl_length A vector — each element is either the literal `"full"`
#'   (use all rows) or a numeric/integer giving the window length. Default
#'   `"full"`.
#'
#' @return A `data.frame` with one row per `chl_length` element, the first
#'   column labelling the row and the remaining columns holding the
#'   development factors.
#' @export
#'
#' @examples
#' cum <- matrix(c(10, 30, 32,  20, 27, NA,  15, NA, NA), nrow = 3, byrow = TRUE)
#' create_chl_coefs(cum, chl_length = c("full", 2))
create_chl_coefs <- function(cum_trg, chl_length = "full") {
  chl_names <- numeric()
  rows <- nrow(cum_trg)
  chl_results <- matrix(NA_real_, nrow = length(chl_length),
                        ncol = ncol(cum_trg))
  for (i in seq_along(chl_length)) {
    act_length <- ifelse(chl_length[i] == "full", rows,
                         as.numeric(chl_length[i]))
    chl_names[i] <- act_length
    for (j in seq_len(ncol(cum_trg))) {
      if (j < 2) next
      num <- sum(cum_trg[max((rows - j + 1) - act_length + 1, 1):(rows - j + 1), j],
                 na.rm = TRUE)
      den <- sum(cum_trg[max((rows - j + 1) - act_length + 1, 1):(rows - j + 1), j - 1],
                 na.rm = TRUE)
      chl_results[i, j] <- dplyr::coalesce(num / den, 1)
    }
  }
  chl_results[, 1] <- NA_real_
  colnames(chl_results) <- 0:(ncol(chl_results) - 1)
  df_results <- data.frame(CH_L_lengths = paste0("chain_ladder - ", chl_length))
  df_results <- cbind(df_results, chl_results)
  return(df_results)
}


#' Cumulative product of chain-ladder factors (ultimate development)
#'
#' Given a one-row data frame of development factors as returned by
#' [create_chl_coefs()], computes the cumulative product from each
#' development period to the tail.
#'
#' @param chl_coefs A one-row data frame whose first column is a label and
#'   whose other columns hold development factors. (As returned by
#'   [create_chl_coefs()].)
#' @param name Character — label for the resulting row.
#'
#' @return A character vector of cumulative-product factors with `name` as
#'   the first element.
#' @export
create_product_coefs <- function(chl_coefs, name = "Product") {
  chl_coefs <- unname(chl_coefs)
  product_coefs <- character(length(chl_coefs))
  # i = 1 is the label column ("chain_ladder - full") and i = 2 is the
  # development column with no factor; both are overwritten below, so we
  # skip them here to avoid a spurious "NAs introduced by coercion" warning
  # from coercing the label column to numeric.
  for (i in seq_along(chl_coefs)) {
    if (i <= 2) next
    product_coefs[i] <- tryCatch(
      as.character(prod(suppressWarnings(
        as.numeric(chl_coefs[1, i:ncol(chl_coefs)])
      ), na.rm = TRUE)),
      error = function(e) NA_character_
    )
  }
  product_coefs[1] <- name
  product_coefs[2] <- NA_character_
  return(product_coefs)
}


#' Average development factors from a CHL factor triangle
#'
#' Averages the per-cell development factors of a CHL factor triangle along
#' diagonals. For each requested window length, returns one row with the
#' simple-average factor per development period.
#'
#' @param chl_trg A development-factor triangle (e.g. the output of
#'   [create_chl_coef_triangle()]).
#' @param avg_length Vector — each element either `"full"` (use the full
#'   diagonal) or an integer giving the window length.
#'
#' @return A `data.frame` with one row per `avg_length` element.
#' @export
create_avg_coefs <- function(chl_trg, avg_length = "full") {
  rows <- nrow(chl_trg)
  diag_data <- NULL
  for (i in rows:1) {
    if (i == rows) {
      diag_data <- diag_reader(chl_trg, diag_num = i)
    } else {
      diag_data <- cbind(
        diag_data,
        c(diag_reader(trg = chl_trg, diag_num = i), rep(NA, rows - i))
      )
    }
  }
  if (is.null(dim(diag_data))) diag_data <- matrix(diag_data, ncol = 1)

  avg_names <- numeric()
  avg_results <- matrix(NA_real_, nrow = length(avg_length),
                        ncol = ncol(chl_trg))

  for (i in seq_along(avg_length)) {
    act_length <- ifelse(avg_length[i] == "full", rows,
                         as.numeric(avg_length[i]))
    avg_names[i] <- act_length
    avg_results[i, ] <- rowMeans(diag_data[, seq_len(act_length), drop = FALSE],
                                 na.rm = TRUE)
  }

  colnames(avg_results) <- 0:(ncol(avg_results) - 1)
  df_results <- data.frame(Average_DF_lengths = paste0("Average DF - ",
                                                       avg_length))
  df_results <- cbind(df_results, avg_results)
  return(df_results)
}


#' Volume-weighted CHL factors with an explicit weight triangle
#'
#' Same idea as [create_chl_coefs()] but every cell is weighted by an
#' arbitrary `trg_weight` matrix evaluated at the **previous** column
#' (`j - 1`). Useful when the natural exposure differs from the cumulative
#' triangle itself (e.g. paid claims weighted by exposure-as-of-prior-period).
#'
#' @param cum_trg Cumulative triangle.
#' @param trg_weight Weight matrix of the same shape as `cum_trg`.
#' @param chl_length As in [create_chl_coefs()].
#'
#' @return A `data.frame` analogous to the output of [create_chl_coefs()].
#' @export
create_chl_coefs_weighted <- function(cum_trg, trg_weight, chl_length = "full") {
  chl_names <- numeric()
  rows <- nrow(cum_trg)
  chl_results <- matrix(NA_real_, nrow = length(chl_length),
                        ncol = ncol(cum_trg))
  for (i in seq_along(chl_length)) {
    act_length <- ifelse(chl_length[i] == "full", rows,
                         as.numeric(chl_length[i]))
    chl_names[i] <- act_length
    for (j in seq_len(ncol(cum_trg))) {
      if (j < 2) next
      idx <- max((rows - j + 1) - act_length + 1, 1):(rows - j + 1)
      num <- sum(cum_trg[idx, j] / cum_trg[idx, j - 1] * trg_weight[idx, j - 1],
                 na.rm = TRUE)
      den <- sum(trg_weight[idx, j - 1], na.rm = TRUE)
      chl_results[i, j] <- dplyr::coalesce(num / den, 1)
    }
  }
  chl_results[, 1] <- NA_real_
  colnames(chl_results) <- 0:(ncol(chl_results) - 1)
  df_results <- data.frame(CH_L_lengths = paste0("chain_ladder - ", chl_length))
  df_results <- cbind(df_results, chl_results)
  return(df_results)
}


#' Volume-weighted CHL factors with weight at the *current* column
#'
#' Variant of [create_chl_coefs_weighted()] that uses `trg_weight[, j]`
#' instead of `trg_weight[, j - 1]`, i.e. the weight evaluated at the
#' developed (forward-looking) column.
#'
#' @inheritParams create_chl_coefs_weighted
#' @return A `data.frame` analogous to the output of [create_chl_coefs()].
#' @export
create_chl_coefs_weighted_future <- function(cum_trg, trg_weight,
                                             chl_length = "full") {
  chl_names <- numeric()
  rows <- nrow(cum_trg)
  chl_results <- matrix(NA_real_, nrow = length(chl_length),
                        ncol = ncol(cum_trg))
  for (i in seq_along(chl_length)) {
    act_length <- ifelse(chl_length[i] == "full", rows,
                         as.numeric(chl_length[i]))
    chl_names[i] <- act_length
    for (j in seq_len(ncol(cum_trg))) {
      if (j < 2) next
      idx <- max((rows - j + 1) - act_length + 1, 1):(rows - j + 1)
      num <- sum(cum_trg[idx, j] / cum_trg[idx, j - 1] * trg_weight[idx, j],
                 na.rm = TRUE)
      den <- sum(trg_weight[idx, j], na.rm = TRUE)
      chl_results[i, j] <- dplyr::coalesce(num / den, 1)
    }
  }
  chl_results[, 1] <- NA_real_
  colnames(chl_results) <- 0:(ncol(chl_results) - 1)
  df_results <- data.frame(CH_L_lengths = paste0("chain_ladder - ", chl_length))
  df_results <- cbind(df_results, chl_results)
  return(df_results)
}


#' Plotly visualisation of selected columns of a CHL triangle
#'
#' Creates an interactive `plotly` line+marker chart of the selected columns
#' of `data_matrix`, with the row names used as the time axis.
#'
#' @param data_matrix A named matrix where row names act as the x-axis.
#' @param columns Character or numeric vector — which columns to plot.
#'
#' @return A `plotly` htmlwidget.
#' @export
#'
#' @examples
#' \dontrun{
#'   trg <- matrix(c(1, 1.2, 1.05, 1, 1.3, NA, 1, NA, NA), 3,
#'                 dimnames = list(c("2022", "2023", "2024"), c("0", "1", "2")))
#'   create_chl_trg_visualization(trg, columns = c("1", "2"))
#' }
create_chl_trg_visualization <- function(data_matrix, columns) {
  if (!requireNamespace("plotly", quietly = TRUE)) {
    stop("Package 'plotly' is required for create_chl_trg_visualization(). ",
         "Install it with install.packages(\"plotly\").",
         call. = FALSE)
  }
  columns <- as.character(columns)
  data <- as.data.frame(data_matrix)
  data$time <- rownames(data_matrix)

  if (any(!columns %in% colnames(data))) {
    stop("One or more specified columns do not exist in the data matrix.")
  }

  selected_data <- data[, c("time", columns)]

  initial_column <- columns[1]
  plot <- plotly::plot_ly(
    data = selected_data,
    x = ~ as.numeric(time),
    y = as.numeric(selected_data[[initial_column]]),
    type = "scatter", mode = "lines+markers",
    name = initial_column
  )

  if (length(columns) > 1) {
    for (col in columns[-1]) {
      plot <- plotly::add_trace(plot,
                                y = as.numeric(selected_data[[col]]),
                                name = col)
    }
  }
  return(plot)
}


#' PVZP-style plotly visualisation (string x-axis)
#'
#' Like [create_chl_trg_visualization()], but the x-axis is left as the raw
#' character row names (no coercion to numeric).
#'
#' @inheritParams create_chl_trg_visualization
#' @return A `plotly` htmlwidget.
#' @export
create_chl_trg_visualization_pvzp <- function(data_matrix, columns) {
  if (!requireNamespace("plotly", quietly = TRUE)) {
    stop("Package 'plotly' is required for create_chl_trg_visualization_pvzp(). ",
         "Install it with install.packages(\"plotly\").",
         call. = FALSE)
  }
  columns <- as.character(columns)
  data <- as.data.frame(data_matrix)
  data$time <- rownames(data_matrix)

  if (any(!columns %in% colnames(data))) {
    stop("One or more specified columns do not exist in the data matrix.")
  }

  selected_data <- data[, c("time", columns)]

  initial_column <- columns[1]
  plot <- plotly::plot_ly(
    data = selected_data,
    x = ~ time,
    y = as.numeric(selected_data[[initial_column]]),
    type = "scatter", mode = "lines+markers",
    name = initial_column
  )

  if (length(columns) > 1) {
    for (col in columns[-1]) {
      plot <- plotly::add_trace(plot,
                                y = as.numeric(selected_data[[col]]),
                                name = col)
    }
  }
  return(plot)
}
