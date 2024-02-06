test_that("Extract_Time_in_mins works", {
  expect_equal(Extract_Time_in_mins("PT1H30S"), 60.5)
})

test_that("Get_Video_Detail", {
  expect_equal(nrow(Get_Video_Detail("Ks-_Mh1QhMc", "AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")), 1)
})

test_that("Get_Video_Category", {
  expect_equal(nrow(Get_Video_Category("22,20", "AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")), 2)
})

# Testing get_monthly_uploads
test_that("YTExploreR_get_uploads returns the correct row", {
  monthly_uploads_result <- get_monthly_uploads('UCQKnyICqWksz8ygILHS01gQ', 2019)[1,1]
  expect_equal(monthly_uploads_result, "2019-01-30T18:11:57+00:00")
})

# Further testing get_monthly_uploads
test_that("get_monthly_uploads returns expected data", {
  monthly_uploads_nrow <- nrow(get_monthly_uploads("UCQKnyICqWksz8ygILHS01gQ", 2020))
  expect_equal(monthly_uploads_nrow, 454)
})

# Testing format_date
test_that("format_date returns correctly formatted date range", {
  expected_start_date <- "2020-1-01T00:00:00Z"
  expected_end_date <- "2020-2-01T00:00:00Z"

  result <- format_date(1, 2020)

  expect_equal(result$start_date, expected_start_date)
  expect_equal(result$end_date, expected_end_date)
})

# Testing visualize_hourly_seasonal
test_that("visualize_hourly_patterns generates a ggplot object", {
  visualize_hourly_result <- visualize_hourly_patterns(get_monthly_uploads("UCqFMzb-4AUf6WAIbl132QKA", 2022))
  expect_true(inherits(visualize_hourly_result, "gg"))
})

# Testing visualize_monthly_uploads return inherit object
test_that("visualize_monthly_uploads generates a ggplot object", {
  visualize_monthly_result <- visualize_monthly_uploads(get_monthly_uploads("UCqFMzb-4AUf6WAIbl132QKA", 2022))
  expect_true(inherits(visualize_monthly_result, "gg"))
})

