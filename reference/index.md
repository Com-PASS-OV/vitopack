# Package index

## Triangles

Build, cumulate, and visualise development triangles.

- [`create_triangle()`](https://donvito.github.io/vitopack/reference/create_triangle.md)
  : Build a development triangle from row-level claims data
- [`create_cumulative_triangle()`](https://donvito.github.io/vitopack/reference/create_cumulative_triangle.md)
  : Cumulate a development triangle along columns
- [`create_decumulative_triangle()`](https://donvito.github.io/vitopack/reference/create_decumulative_triangle.md)
  : De-cumulate a cumulative development triangle
- [`create_annual_triangle()`](https://donvito.github.io/vitopack/reference/create_annual_triangle.md)
  : Re-aggregate a per-period triangle to an annual triangle
- [`create_run_off_check()`](https://donvito.github.io/vitopack/reference/create_run_off_check.md)
  : Run-off check across all diagonals
- [`diag_reader()`](https://donvito.github.io/vitopack/reference/diag_reader.md)
  : Read values along a triangle diagonal
- [`diag_sums()`](https://donvito.github.io/vitopack/reference/diag_sums.md)
  : Cumulative diagonal sums of a triangle
- [`diag_writer()`](https://donvito.github.io/vitopack/reference/diag_writer.md)
  : Append the latest diagonal of a new triangle to an old one
- [`triangle_namer()`](https://donvito.github.io/vitopack/reference/triangle_namer.md)
  : Rename a triangle's rows/columns for printing

## Chain-ladder

Development factors and ultimate projections.

- [`create_chl_coef_triangle()`](https://donvito.github.io/vitopack/reference/create_chl_coef_triangle.md)
  : Element-wise chain-ladder development factor triangle

- [`create_chl_coefs()`](https://donvito.github.io/vitopack/reference/create_chl_coefs.md)
  : Volume-weighted chain-ladder development factors

- [`create_chl_coefs_weighted()`](https://donvito.github.io/vitopack/reference/create_chl_coefs_weighted.md)
  : Volume-weighted CHL factors with an explicit weight triangle

- [`create_chl_coefs_weighted_future()`](https://donvito.github.io/vitopack/reference/create_chl_coefs_weighted_future.md)
  :

  Volume-weighted CHL factors with weight at the *current* column

- [`create_avg_coefs()`](https://donvito.github.io/vitopack/reference/create_avg_coefs.md)
  : Average development factors from a CHL factor triangle

- [`create_product_coefs()`](https://donvito.github.io/vitopack/reference/create_product_coefs.md)
  : Cumulative product of chain-ladder factors (ultimate development)

- [`create_chl_trg_visualization()`](https://donvito.github.io/vitopack/reference/create_chl_trg_visualization.md)
  : Plotly visualisation of selected columns of a CHL triangle

- [`create_chl_trg_visualization_pvzp()`](https://donvito.github.io/vitopack/reference/create_chl_trg_visualization_pvzp.md)
  : PVZP-style plotly visualisation (string x-axis)

## Policy columns & exposures

- [`create_find_columns()`](https://donvito.github.io/vitopack/reference/create_find_columns.md)
  : Add zero/value columns based on equality conditions

- [`create_policy_exposure_columns_m()`](https://donvito.github.io/vitopack/reference/create_policy_exposure_columns_m.md)
  : Build per-period exposure columns (in years)

- [`create_policy_exposure_days_columns()`](https://donvito.github.io/vitopack/reference/create_policy_exposure_days_columns.md)
  : Build per-period exposure columns (in days)

- [`create_multiple_columns_m()`](https://donvito.github.io/vitopack/reference/create_multiple_columns_m.md)
  : Multiply a set of columns by another column

- [`bind_with_source()`](https://donvito.github.io/vitopack/reference/bind_with_source.md)
  :

  Row-bind a list of data frames with a `source` column

## Czech birth numbers

- [`rc_to_birth_day()`](https://donvito.github.io/vitopack/reference/rc_to_birth_day.md)
  [`rc_to_birth_day_2()`](https://donvito.github.io/vitopack/reference/rc_to_birth_day.md)
  [`rc_to_birth_day_3()`](https://donvito.github.io/vitopack/reference/rc_to_birth_day.md)
  : Convert a Czech birth number to a date of birth

## Color palettes

- [`rgb_colors_for_plot()`](https://donvito.github.io/vitopack/reference/rgb_colors_for_plot.md)
  : Build a smooth RGB rainbow data frame

- [`get_colors()`](https://donvito.github.io/vitopack/reference/get_colors.md)
  [`get_colors_plus()`](https://donvito.github.io/vitopack/reference/get_colors.md)
  [`get_colors_duo()`](https://donvito.github.io/vitopack/reference/get_colors.md)
  :

  Pick `n` evenly spaced colors from a rainbow data frame

- [`plot_color_bars()`](https://donvito.github.io/vitopack/reference/plot_color_bars.md)
  : Quick visual sanity check of a generated palette

- [`rainbow_cat()`](https://donvito.github.io/vitopack/reference/rainbow_cat.md)
  : Print colored text to the console (rainbow cycle)

## Misc

- [`load_excel_sheets()`](https://donvito.github.io/vitopack/reference/load_excel_sheets.md)
  :

  Load every sheet of an Excel `.xlsx` workbook into a named list

- [`load_xlsb_sheets()`](https://donvito.github.io/vitopack/reference/load_xlsb_sheets.md)
  :

  Load every sheet of a binary Excel `.xlsb` workbook into a named list

- [`numeric_format()`](https://donvito.github.io/vitopack/reference/numeric_format.md)
  : Format a number with a thin space as the thousands separator
