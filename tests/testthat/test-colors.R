test_that("rgb_colors_for_plot returns a tibble with three integer-valued channels", {
  rgb_df <- rgb_colors_for_plot()
  expect_s3_class(rgb_df, "tbl_df")
  expect_named(rgb_df, c("r", "g", "b"))
  expect_true(all(rgb_df$r %in% 0:255))
  expect_true(all(rgb_df$g %in% 0:255))
  expect_true(all(rgb_df$b %in% 0:255))
  # Default `c(3:6, 1)` → 5 segments × 256 rows
  expect_equal(nrow(rgb_df), 5 * 256)
})

test_that("rgb_colors_for_plot validates input range", {
  expect_error(rgb_colors_for_plot(c(0, 3)), "1:6")
  expect_error(rgb_colors_for_plot(c(3, 7)), "1:6")
})

test_that("get_colors picks endpoint colors for n = 2", {
  rgb_df <- rgb_colors_for_plot()
  cols <- get_colors(rgb_df, 2)
  expect_length(cols, 2)
  expect_match(cols, "^#[0-9A-Fa-f]{6}$")
})

test_that("get_colors returns the requested number of colors", {
  rgb_df <- rgb_colors_for_plot()
  expect_length(get_colors(rgb_df, 7), 7)
  expect_length(get_colors_plus(rgb_df, 7), 7)
  expect_length(get_colors_duo(rgb_df, 7),  7)
})

test_that("get_colors* family rejects n < 2", {
  rgb_df <- rgb_colors_for_plot()
  expect_error(get_colors(rgb_df, 1),      "2 or more")
  expect_error(get_colors_plus(rgb_df, 0), "2 or more")
  expect_error(get_colors_duo(rgb_df, 1),  "2 or more")
})

test_that("rainbow_cat does not throw and prints something", {
  expect_output(rainbow_cat("hi", 1))
  # Cycles modulo 8
  expect_output(rainbow_cat("hi", 9))
})

test_that("numeric_format adds thin space group separator", {
  expect_equal(numeric_format(1234567), "1 234 567")
  expect_equal(numeric_format(89.5),    "89.5")
})
