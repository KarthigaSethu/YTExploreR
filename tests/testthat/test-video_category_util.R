test_that("Extract_Time_in_mins works", {
  expect_equal(Extract_Time_in_mins("PT1H30S"), 60.5)
})

test_that("Get_Video_Detail", {
  expect_equal(nrow(Get_Video_Detail("Ks-_Mh1QhMc", "AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")), 1)
})

test_that("Get_Video_Category", {
  expect_equal(nrow(Get_Video_Category("22,20", "AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")), 2)
})
