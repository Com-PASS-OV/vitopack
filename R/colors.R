#' Print colored text to the console (rainbow cycle)
#'
#' Prints `print_text` to the console wrapped in an ANSI color code chosen by
#' `color_num`. The color index cycles modulo 8 so any positive integer is
#' valid.
#'
#' @param print_text Character -- the text to print.
#' @param color_num Integer -- color index (cycled modulo 8).
#'
#' @return Invisible `NULL`. Called for the side effect of printing.
#' @export
#'
#' @examples
#' rainbow_cat("Hello in green", 3)
rainbow_cat <- function(print_text, color_num) {
  colors <- c(
    "\033[31m", # red
    "\033[33m", # orange/yellow
    "\033[32m", # green
    "\033[36m", # cyan
    "\033[34m", # blue
    "\033[35m", # purple
    "\033[91m", # light red
    "\033[95m"  # light pink
  )
  adjusted_color_num <- (color_num - 1) %% 8 + 1
  selected_color <- colors[[adjusted_color_num]]
  cat(selected_color, print_text, "\033[0m\n")
  invisible(NULL)
}


#' Build a smooth RGB rainbow data frame
#'
#' Produces a tibble of `r`, `g`, `b` channel values walking through the six
#' canonical rainbow segments (red -> yellow -> green -> cyan -> blue -> purple
#' -> red). The argument selects which segments to include and in which order.
#'
#' @param colors_changes_vector Integer vector with values in `1:6`. Default
#'   `c(3:6, 1)` gives a green -> red sweep.
#'
#' @return A [tibble::tibble()] with columns `r`, `g`, `b`.
#' @export
#'
#' @examples
#' head(rgb_colors_for_plot())
rgb_colors_for_plot <- function(colors_changes_vector = c(3:6, 1)) {
  if (max(colors_changes_vector) > 6) {
    stop("`colors_changes_vector` must be an integer vector with values in 1:6.",
         call. = FALSE)
  }
  if (min(colors_changes_vector) < 1) {
    stop("`colors_changes_vector` must be an integer vector with values in 1:6.",
         call. = FALSE)
  }

  colors_changes <- list()
  colors_changes[[1]] <- tibble::tibble(r = rep(255, 256), g = 0:255,    b = rep(0, 256))
  colors_changes[[2]] <- tibble::tibble(r = 255:0,         g = rep(255, 256), b = rep(0, 256))
  colors_changes[[3]] <- tibble::tibble(r = rep(0, 256),   g = rep(255, 256), b = 0:255)
  colors_changes[[4]] <- tibble::tibble(r = rep(0, 256),   g = 255:0,    b = rep(255, 256))
  colors_changes[[5]] <- tibble::tibble(r = 0:255,         g = rep(0, 256),  b = rep(255, 256))
  colors_changes[[6]] <- tibble::tibble(r = rep(255, 256), g = rep(0, 256),  b = 255:0)

  RGB <- tibble::tibble(r = numeric(), g = numeric(), b = numeric())
  for (i in colors_changes_vector) {
    RGB <- rbind(RGB, colors_changes[[i]])
  }
  return(RGB)
}


#' Pick `n` evenly spaced colors from a rainbow data frame
#'
#' Three flavours are exported. They differ only in the post-processing they
#' apply after picking equally-spaced rows from `rgb_df`:
#'
#' * `get_colors()` -- no post-processing.
#' * `get_colors_plus()` -- every other color is darkened (x0.75) or
#'   lightened (towards 255 with weight 0.7), creating a strong duo pattern.
#' * `get_colors_duo()` -- every other color is darkened (x0.8) or lightened
#'   (weight 0.6), milder than the `_plus` variant.
#'
#' @param rgb_df A data frame with columns `r`, `g`, `b`, e.g. produced by
#'   [rgb_colors_for_plot()].
#' @param n_colors Integer >= 2 -- number of colors to return.
#'
#' @return A character vector of length `n_colors` with hex color codes
#'   (`"#RRGGBB"`).
#' @name get_colors
#' @examples
#' rgb_df <- rgb_colors_for_plot()
#' get_colors(rgb_df, 5)
#' get_colors_plus(rgb_df, 6)
#' get_colors_duo(rgb_df, 6)
NULL

#' @rdname get_colors
#' @export
get_colors <- function(rgb_df, n_colors) {
  if (n_colors < 2) stop("`n_colors` must be 2 or more.", call. = FALSE)

  if (n_colors == 2) {
    selected_colors <- rgb_df[c(1, nrow(rgb_df)), ]
  } else {
    quantiles <- as.numeric(stats::quantile(seq_len(nrow(rgb_df)),
                                            probs = seq(0, 1, length.out = n_colors)))
    selected_colors <- rgb_df[round(quantiles), ]
  }
  apply(selected_colors, 1, function(row) {
    grDevices::rgb(row[["r"]], row[["g"]], row[["b"]], maxColorValue = 255)
  })
}

#' @rdname get_colors
#' @export
get_colors_plus <- function(rgb_df, n_colors) {
  if (n_colors < 2) stop("`n_colors` must be 2 or more.", call. = FALSE)

  if (n_colors == 2) {
    selected_colors <- rgb_df[c(1, nrow(rgb_df)), ]
  } else {
    quantiles <- as.numeric(stats::quantile(seq_len(nrow(rgb_df)),
                                            probs = seq(0, 1, length.out = n_colors)))
    selected_colors <- rgb_df[round(quantiles), ]
  }

  for (i in seq_len(nrow(selected_colors))) {
    if (i %% 2 == 0) {
      if (i %% 4 == 0) {
        selected_colors[i, ] <- selected_colors[i, ] * 0.75
      } else {
        selected_colors[i, ] <- selected_colors[i, ] + (255 - selected_colors[i, ]) * 0.7
      }
    }
  }

  apply(selected_colors, 1, function(row) {
    grDevices::rgb(row[["r"]], row[["g"]], row[["b"]], maxColorValue = 255)
  })
}

#' @rdname get_colors
#' @export
get_colors_duo <- function(rgb_df, n_colors) {
  if (n_colors < 2) stop("`n_colors` must be 2 or more.", call. = FALSE)

  if (n_colors == 2) {
    selected_colors <- rgb_df[c(1, nrow(rgb_df)), ]
  } else {
    quantiles <- as.numeric(stats::quantile(seq_len(nrow(rgb_df)),
                                            probs = seq(0, 1, length.out = n_colors)))
    selected_colors <- rgb_df[round(quantiles), ]
  }

  for (i in seq_len(nrow(selected_colors))) {
    if (i %% 2 == 0) {
      selected_colors[i, ] <- selected_colors[i, ] * 0.8
    } else {
      selected_colors[i, ] <- selected_colors[i, ] + (255 - selected_colors[i, ]) * 0.6
    }
  }

  apply(selected_colors, 1, function(row) {
    grDevices::rgb(row[["r"]], row[["g"]], row[["b"]], maxColorValue = 255)
  })
}


#' Quick visual sanity check of a generated palette
#'
#' Convenience wrapper that calls [rgb_colors_for_plot()] and
#' [get_colors_duo()] and renders the result as a stacked bar chart.
#'
#' @param n_colors Integer >= 2 -- number of palette stops to plot.
#'
#' @return Invisible `NULL`. Called for the side effect of plotting.
#' @export
#'
#' @examples
#' if (interactive()) plot_color_bars(12)
plot_color_bars <- function(n_colors) {
  rgb <- rgb_colors_for_plot()
  color_vector <- get_colors_duo(rgb, n_colors)
  data <- data.frame(
    group = rep(1, n_colors),
    value = rep(1, n_colors),
    color = color_vector
  )
  graphics::barplot(
    height = data$value,
    col    = data$color,
    space  = 0,
    border = NA,
    main   = paste("Stacked bar chart with", n_colors, "colors"),
    xlab   = "Colors",
    ylab   = "Value"
  )
  invisible(NULL)
}