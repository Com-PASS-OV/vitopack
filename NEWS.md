# vitopack 0.1.1

* Address CRAN reviewer feedback (Benjamin Altmann, 2026-05-04):
  * Added a reference to the chain-ladder methodology in the
    `DESCRIPTION` field: Mack (1993) <doi:10.2143/AST.23.2.2005092>.
  * Removed the `if (interactive())` wrapper from the `plot_color_bars()`
    example -- the function works in non-interactive sessions too.

# vitopack 0.1.0

* Initial release.
* Triangles & chain-ladder helpers: `create_triangle()`,
  `create_cumulative_triangle()`, `create_decumulative_triangle()`,
  `create_annual_triangle()`, `create_run_off_check()`, `diag_reader()`,
  `diag_sums()`, `diag_writer()`, `triangle_namer()`.
* Development factors: `create_chl_coef_triangle()`, `create_chl_coefs()`,
  `create_chl_coefs_weighted()`, `create_chl_coefs_weighted_future()`,
  `create_avg_coefs()`, `create_product_coefs()`.
* Plotly visualisations: `create_chl_trg_visualization()`,
  `create_chl_trg_visualization_pvzp()`.
* Policy column helpers: `create_find_columns()`,
  `create_policy_exposure_columns_m()`,
  `create_policy_exposure_days_columns()`,
  `create_multiple_columns_m()`, `bind_with_source()`.
* Czech birth-number parsers: `rc_to_birth_day()`, `rc_to_birth_day_2()`,
  `rc_to_birth_day_3()`.
* Color palette helpers: `rgb_colors_for_plot()`, `get_colors()`,
  `get_colors_plus()`, `get_colors_duo()`, `plot_color_bars()`,
  `rainbow_cat()`.
* I/O helpers: `load_excel_sheets()`, `load_xlsb_sheets()`,
  `numeric_format()`.
