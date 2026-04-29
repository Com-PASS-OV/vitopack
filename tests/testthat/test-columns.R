test_that("create_find_columns creates per-category value columns", {
  dt <- data.frame(line = c("MTPL", "CASCO", "MTPL"),
                   premium = c(100, 200, 300))
  res <- create_find_columns(
    data            = dt,
    condition_names = c("MTPL", "CASCO"),
    new_cols_names  = c("MTPL_premium", "CASCO_premium"),
    condition_var   = "line",
    values_var      = "premium"
  )
  expect_s3_class(res, "data.table")
  expect_equal(res$MTPL_premium,  c(100, 0, 300))
  expect_equal(res$CASCO_premium, c(0, 200, 0))
})

test_that("create_find_columns leaves zeros when no row matches", {
  dt <- data.frame(line = c("MTPL", "CASCO"),
                   premium = c(100, 200))
  res <- create_find_columns(
    data            = dt,
    condition_names = "OTHER",
    new_cols_names  = "OTHER_premium",
    condition_var   = "line",
    values_var      = "premium"
  )
  expect_equal(res$OTHER_premium, c(0, 0))
})

test_that("create_policy_exposure_columns_m respects policy boundaries", {
  dt <- data.frame(
    policy_start = as.Date(c("2024-01-15", "2024-06-01")),
    policy_end   = as.Date(c("2024-12-31", "2025-05-31"))
  )
  res <- create_policy_exposure_columns_m(
    data             = dt,
    exp_names        = c("exp_q1", "exp_q4"),
    start_months     = c("2024-01-01", "2024-10-01"),
    end_months       = c("2024-03-31", "2024-12-31"),
    start_policy_var = "policy_start",
    end_policy_var   = "policy_end"
  )
  # Q1 of policy 1 starts at 2024-01-15 and ends 2024-03-31 → 77 days / 365
  expect_equal(res$exp_q1[1], 77 / 365, tolerance = 1e-9)
  # Q1 of policy 2 starts after the policy began → 0
  expect_equal(res$exp_q1[2], 0)
  # Q4 of policy 1 = full quarter (Oct-Dec) = 92 days / 365
  expect_equal(res$exp_q4[1], 92 / 365, tolerance = 1e-9)
})

test_that("create_policy_exposure_days_columns returns rounded days", {
  dt <- data.frame(
    policy_start = as.Date("2024-01-15"),
    policy_end   = as.Date("2024-12-31")
  )
  res <- create_policy_exposure_days_columns(
    data             = dt,
    exp_names        = "exp_jan",
    start_months     = "2024-01-01",
    end_months       = "2024-01-31",
    start_policy_var = "policy_start",
    end_policy_var   = "policy_end"
  )
  expect_equal(res$exp_jan, 17)  # 15..31 inclusive
})

test_that("create_multiple_columns_m multiplies and renames", {
  df <- data.frame(
    exp_q1  = c(0.25, 0.5),
    exp_q2  = c(0.5, 0.5),
    premium = c(100, 200)
  )
  res <- create_multiple_columns_m(
    data               = df,
    new_variable_names = c("prem_q1", "prem_q2"),
    multiple_exp_names = c("exp_q1", "exp_q2"),
    multiply_var       = "premium"
  )
  expect_true(all(c("prem_q1", "prem_q2") %in% names(res)))
  expect_equal(res$prem_q1, c(25, 100))
  expect_equal(res$prem_q2, c(50, 100))
})

test_that("bind_with_source attaches the source name", {
  res <- bind_with_source(list(
    a = data.frame(x = 1:2, y = 3:4),
    b = data.frame(x = 5,   z = 9)
  ))
  expect_s3_class(res, "data.table")
  expect_equal(unique(res$source), c("a", "b"))
  expect_true("z" %in% names(res))
})

test_that("bind_with_source returns NULL on empty input", {
  expect_null(bind_with_source(list()))
})
