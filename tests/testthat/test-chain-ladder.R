trg_cum <- matrix(c(
  10, 15, 17,
  20, 27, NA,
  15, NA, NA
), nrow = 3, byrow = TRUE)

test_that("create_chl_coef_triangle gives column j / column j-1", {
  res <- create_chl_coef_triangle(trg_cum)
  expect_true(is.na(res[1, 1]))
  expect_equal(res[1, 2], 15 / 10)
  expect_equal(res[2, 2], 27 / 20)
  expect_equal(res[1, 3], 17 / 15)
  # NA stays where the cumulative triangle was NA
  expect_true(is.na(res[2, 3]))
})

test_that("create_chl_coefs returns one row per requested length", {
  res <- create_chl_coefs(trg_cum, chl_length = c("full", 2))
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 2)
  # First column is NA by convention, label column counted separately
  expect_true(is.na(res[1, 2]))
})

test_that("create_chl_coefs volume-weighted matches the manual calculation", {
  res <- create_chl_coefs(trg_cum, chl_length = "full")
  # Column 2 ('1' label): (10 + 20) → (15 + 27) → 42 / 30 = 1.4
  expect_equal(res[["1"]][1], 42 / 30)
  # Column 3 ('2' label): single row contribution: 17 / 15
  expect_equal(res[["2"]][1], 17 / 15)
})

test_that("create_avg_coefs returns one row per requested length", {
  chl_trg <- create_chl_coef_triangle(trg_cum)
  res <- create_avg_coefs(chl_trg, avg_length = c("full", 1))
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 2)
})

test_that("create_chl_coefs_weighted with weight = cum_trg matches volume-weighted CHL", {
  # The volume-weighted CHL formula is sum(cum[, j]) / sum(cum[, j-1]);
  # the per-cell weighted formula collapses to that exact thing
  # iff the weights at column j-1 are the cum_trg values themselves.
  res_unw <- create_chl_coefs(trg_cum, chl_length = "full")
  res_w   <- create_chl_coefs_weighted(trg_cum, trg_weight = trg_cum,
                                       chl_length = "full")
  for (col in c("1", "2")) {
    expect_equal(res_w[[col]][1], res_unw[[col]][1], tolerance = 1e-9)
  }
})

test_that("create_chl_coefs_weighted with constant weights = simple mean of factors", {
  weight <- matrix(1, nrow = nrow(trg_cum), ncol = ncol(trg_cum))
  weight[is.na(trg_cum)] <- NA
  res_w <- create_chl_coefs_weighted(trg_cum, weight, chl_length = "full")
  # Column "1": mean of 15/10 and 27/20 = 1.425
  expect_equal(res_w[["1"]][1], mean(c(15 / 10, 27 / 20)), tolerance = 1e-9)
  # Column "2": single observation 17/15
  expect_equal(res_w[["2"]][1], 17 / 15, tolerance = 1e-9)
})

test_that("create_chl_coefs_weighted_future also runs and respects column shapes", {
  weight <- matrix(1, nrow = nrow(trg_cum), ncol = ncol(trg_cum))
  weight[is.na(trg_cum)] <- NA
  res <- create_chl_coefs_weighted_future(trg_cum, weight, chl_length = "full")
  expect_equal(ncol(res), ncol(trg_cum) + 1)  # label column + ncol coefs
})

test_that("create_product_coefs computes cumulative tail products", {
  chl <- create_chl_coefs(trg_cum, chl_length = "full")
  prod_row <- create_product_coefs(chl, name = "Ult")
  expect_equal(prod_row[1], "Ult")
  expect_true(is.na(prod_row[2]))
})

test_that("create_annual_triangle reduces a quarterly triangle to annual", {
  # 4x4 cumulative triangle (1 year of quarters)
  q_trg <- matrix(NA_real_, 4, 4)
  q_trg[1, ] <- c(1, 2, 3, 4)
  q_trg[2, 1:3] <- c(2, 4, 5)
  q_trg[3, 1:2] <- c(3, 5)
  q_trg[4, 1]   <- 4
  res <- create_annual_triangle(q_trg, period = 4)
  expect_equal(dim(res), c(1, 1))
})
