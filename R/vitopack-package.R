#' vitopack: Actuarial Helpers for Triangles, Exposures and Czech Birth Numbers
#'
#' A collection of utilities that grew out of day-to-day non-life actuarial
#' work at Com-PASS Advisory. The package is split into a few thematic
#' families:
#'
#' * **Triangles & chain-ladder** - [create_triangle()],
#'   [create_cumulative_triangle()], [create_chl_coefs()],
#'   [create_chl_coefs_weighted()], [create_run_off_check()] and friends.
#' * **Policy columns & exposures** - [create_find_columns()],
#'   [create_policy_exposure_columns_m()],
#'   [create_policy_exposure_days_columns()], [create_multiple_columns_m()].
#' * **Czech birth numbers** - [rc_to_birth_day()], [rc_to_birth_day_2()],
#'   [rc_to_birth_day_3()].
#' * **Color palettes** - [rgb_colors_for_plot()], [get_colors()],
#'   [get_colors_plus()], [get_colors_duo()], [plot_color_bars()],
#'   [rainbow_cat()].
#' * **I/O & misc** - [load_excel_sheets()], [load_xlsb_sheets()],
#'   [numeric_format()], [bind_with_source()].
#'
#' @keywords internal
"_PACKAGE"

# Suppress R CMD check NOTEs for non-standard evaluation symbols used by
# data.table and dplyr inside the package's functions.
utils::globalVariables(c(
  ".", ":=", "value", "source"
))

# Mark the package as data.table-aware so that `:=`, `setDT()` and friends
# work when called from inside our exported functions. See
# vignette("datatable-importing", package = "data.table").
.datatable.aware <- TRUE
