trg_inc <- matrix(c(
  10, 5,  2,
  20, 7,  NA,
  15, NA, NA
), nrow = 3, byrow = TRUE)

trg_cum <- matrix(c(
  10, 15, 17,
  20, 27, NA,
  15, NA, NA
), nrow = 3, byrow = TRUE)

test_that("create_cumulative_triangle cumulates along columns", {
  expect_equal(create_cumulative_triangle(trg_inc), trg_cum)
})

test_that("create_decumulative_triangle is the inverse", {
  expect_equal(create_decumulative_triangle(trg_cum), trg_inc)
})

test_that("diag_reader walks the anti-diagonal", {
  trg <- matrix(1:9, nrow = 3)
  # main anti-diagonal: trg[3,1], trg[2,2], trg[1,3] = 3, 5, 7
  expect_equal(diag_reader(trg), c(3, 5, 7))
  expect_equal(diag_reader(trg, diag_num = 1), 1)
})

test_that("diag_sums sums each anti-diagonal", {
  # diag 1: trg[1,1] = 10
  # diag 2: trg[2,1] + trg[1,2] = 20 + 5 = 25
  # diag 3: trg[3,1] + trg[2,2] + trg[1,3] = 15 + 7 + 2 = 24
  expect_equal(diag_sums(trg_inc), c(10, 25, 24))
})

test_that("triangle_namer sets row/col names", {
  named <- triangle_namer(trg_inc, c("2022", "2023", "2024", "2025"))
  expect_equal(rownames(named), c("2022", "2023", "2024"))
  expect_equal(colnames(named), c("0", "1", "2"))
})

test_that("create_triangle assembles a triangle from long data", {
  df <- data.frame(
    origin = c(1, 1, 1, 2, 2, 3),
    dev    = c(0, 1, 2, 0, 1, 0),
    paid   = c(10, 5, 2, 20, 7, 15)
  )
  res <- create_triangle(df, row_num = "origin", col_num = "dev",
                         value = "paid")
  expect_equal(res, trg_inc)
})

test_that("create_triangle filters correctly via cond_variable", {
  df <- data.frame(
    origin = rep(1:3, each = 2),
    dev    = rep(c(0, 1), 3),
    line   = rep(c("MTPL", "CASCO"), 3),
    paid   = c(10, 5, 20, 7, 15, 8)
  )
  res <- create_triangle(df, row_num = "origin", col_num = "dev",
                         value = "paid",
                         cond_variable = "line", cond_value = "MTPL",
                         rows = 3)
  expect_equal(res[1, 1], 10)
  expect_equal(res[3, 1], 15)
})

test_that("diag_writer extends an old triangle with a new diagonal", {
  old <- matrix(c(10, 5,
                  20, NA), nrow = 2, byrow = TRUE)
  new <- matrix(c(10, 5,  3,
                  20, 7,  NA,
                  25, NA, NA), nrow = 3, byrow = TRUE)
  res <- diag_writer(old, new)
  expect_equal(dim(res), c(3, 3))
  expect_equal(res[1, 1], 10)
  expect_equal(res[3, 1], 25)
})

test_that("create_run_off_check returns the right length", {
  expect_length(create_run_off_check(trg_cum), nrow(trg_cum) - 1)
})
