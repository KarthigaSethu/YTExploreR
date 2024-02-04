test_that("Extract_Time_in_mins works", {
  expect_equal(Extract_Time_in_mins("PT1H30S"), 60.5)
})

test_that("Get_Video_Detail", {
  data<-Get_Video_Detail("Ks-_Mh1QhMc", "AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")
  expect_equal(nrow(data), 1)
})

test_that("Get_Video_Category", {
  data <- Get_Video_Category("22,20", "AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")
  expect_equal(nrow(data), 2)
})

test_that("Get_Video_Detail No Value", {
  expect_no_error(Get_Video_Category())
})

test_that("Get_Video_Category No Value", {
  expect_no_error(Get_Video_Category())
})

test_that("Get_Video_Detail dummy API", {
  expect_no_error(Get_Video_Detail("Ks-_Mh1QhMc", "dummy"))
})

test_that("Get_Video_Category dummy API", {
  expect_no_error(Get_Video_Category("22,20", "dummy"))
})

test_that("get_Preference_Breakdown 2", {
  expect_no_error(get_Preference_Breakdown("Ks-_Mh1QhMc,Qf06XDYXCXI"))
})

test_that("get_Preference_Breakdown", {
  videos<-"Ks-_Mh1QhMc,ZTt9gsGcdDo,Qf06XDYXCXI,Qf06XDYXCXI,rC9vw2dSpQo,rC9vw2dSpQo,Ka04Dj7DxGk,bQ5BoolX9Ag,bQ5BoolX9Ag,L8HKweZIOmg,PSs6nxngL6k,zxQyTK8quyY,zxQyTK8quyY,8ZcccMzTz7Y,8ZcccMzTz7Y,YaQEUgIr4Mk,YaQEUgIr4Mk,PSs6nxngL6k,PSs6nxngL6k,02zO75hHpZQ,kDitis0QB9Y,YLADB0ZCWaE,R1dD6khKJh4"
  expect_no_error(get_Preference_Breakdown("videos"))
})

test_that("get_top10_videos", {
  expect_no_error(get_top10_videos("UCtYLUTtgS3k1Fg4y5tAhLbw"))
})

test_that("get_top10_videos", {
  expect_no_error(get_top10_videos())
})

test_that("prepeare data", {
  videos<-"Ks-_Mh1QhMc,ZTt9gsGcdDo,Qf06XDYXCXI,Qf06XDYXCXI,rC9vw2dSpQo,rC9vw2dSpQo,Ka04Dj7DxGk,bQ5BoolX9Ag,bQ5BoolX9Ag,L8HKweZIOmg,PSs6nxngL6k,zxQyTK8quyY,zxQyTK8quyY,8ZcccMzTz7Y,8ZcccMzTz7Y,YaQEUgIr4Mk,YaQEUgIr4Mk,PSs6nxngL6k,PSs6nxngL6k,02zO75hHpZQ,kDitis0QB9Y,YLADB0ZCWaE,R1dD6khKJh4"
  data <- preprare_data(videos)
  expect_equal(nrow(data), 3)
})

