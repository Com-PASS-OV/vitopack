test_that("rc_to_birth_day returns correct date for a man (length 11)", {
  # 1990-06-15
  expect_equal(rc_to_birth_day("900615/1234"), as.Date("1990-06-15"))
})

test_that("rc_to_birth_day length-11 with year < 54 → 21st century", {
  # year 05 with the slash → 2005
  expect_equal(rc_to_birth_day("050615/1234"), as.Date("2005-06-15"))
})

test_that("rc_to_birth_day length-10 (no slash) is treated as 1900s", {
  # nchar != 11 → defaults to 1900s regardless of YY
  expect_equal(rc_to_birth_day("0506151234"), as.Date("1905-06-15"))
})

test_that("rc_to_birth_day handles women (+50 month offset)", {
  # 56 - 50 = 6 → June. 2005-06-15 (year < 54)
  expect_equal(rc_to_birth_day("055615/1234"), as.Date("2005-06-15"))
})

test_that("rc_to_birth_day_2 cut-off is 25", {
  # YY = 24 → 2024
  expect_equal(rc_to_birth_day_2("240615/1234"), as.Date("2024-06-15"))
  # YY = 25 → 1925
  expect_equal(rc_to_birth_day_2("250615/1234"), as.Date("1925-06-15"))
})

test_that("rc_to_birth_day_3 requires length 11 AND YY < 25 to use 21st century", {
  expect_equal(rc_to_birth_day_3("050615/1234"),  as.Date("2005-06-15"))
  expect_equal(rc_to_birth_day_3("0506151234"),   as.Date("1905-06-15"))
})

test_that("rc_to_birth_day is vectorised", {
  res <- rc_to_birth_day(c("900615/1234", "050615/1234"))
  expect_equal(res, as.Date(c("1990-06-15", "2005-06-15")))
})
