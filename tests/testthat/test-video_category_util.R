test_that("Extract_Time_in_mins works", {
  expect_equal(Extract_Time_in_mins("PT1H30S"), 60.5)
})

test_that("Get_Video_Detail", {
  expect_equal(nrow(Get_Video_Detail("Ks-_Mh1QhMc", "AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")), 1)
})

test_that("Get_Video_Category", {
  expect_equal(nrow(Get_Video_Category("22,20", "AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")), 2)
})
<<<<<<< Updated upstream
=======

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
  videos<-"Ks-_Mh1QhMc,ZTt9gsGcdDo,Qf06XDYXCXI,Qf06XDYXCXI,rC9vw2dSpQo,rC9vw2dSpQo
  ,Ka04Dj7DxGk,bQ5BoolX9Ag,bQ5BoolX9Ag,L8HKweZIOmg,PSs6nxngL6k,zxQyTK8quyY,zxQyTK8quyY,
  8ZcccMzTz7Y,8ZcccMzTz7Y,YaQEUgIr4Mk,YaQEUgIr4Mk,PSs6nxngL6k,PSs6nxngL6k,02zO75hHpZQ,
  kDitis0QB9Y,YLADB0ZCWaE,R1dD6khKJh4"
  expect_no_error(get_Preference_Breakdown("videos"))
})

test_that("get_top10_videos", {
  expect_no_error(get_top10_videos("UCtYLUTtgS3k1Fg4y5tAhLbw"))
})

test_that("get_top10_videos", {
  expect_no_error(get_top10_videos())
})


###############################################################################
#Get channel statistics tests

test_that("get_channel_stats_parameters", {
   # Check if both parameters are correct
   expect_no_error({
     get_channel_stats("AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw",
                       c("UCtYLUTtgS3k1Fg4y5tAhLbw",
                         "UCLLw7jmFsvfIVaUFsLs8mlQ"))
   })
 })

test_that("get_channel_stats_invalid_API", {
  # Check if both parameters are correct
  expect_error({
    get_channel_stats(invalid_type_api_key,
                      c("UCtYLUTtgS3k1Fg4y5tAhLbw",
                        "UCLLw7jmFsvfIVaUFsLs8mlQ"))
  })
})


test_that("get_channel_stats handles invalid_channel_ids", {
  # Test case: Empty channel_ids
  expect_error(get_channel_stats("AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw", character(0)),
               "Error: The channel ids must be a non-empty vector of strings")
})

test_that("get_channel_stats handles invalid_params", {
  # Test case: Empty channel_ids
  expect_error(get_channel_stats("api_key", "invalid_channel"),"Error: Unable to parse channel start date.")
})

test_that("get_channel_stats_data_frame_length", {
  # Mock data for testing
  mock_api_key <- "AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw"
  mock_channel_ids <- c("UCtYLUTtgS3k1Fg4y5tAhLbw", "UCLLw7jmFsvfIVaUFsLs8mlQ")

  # Call the get_channel_stats function
  result_df <- get_channel_stats(mock_api_key, mock_channel_ids)

  # Test if the data frame has at least one row
  expect_true(nrow(result_df) >= 1,
              "The data frame should have at least one row")
})

################################################################################
# Display individual channel stats test

#Mock data for testing
mock_channel_stats <- data.frame(
  channelID = c("channel1", "channel2"),
  channelName = c("Channel 1", "Channel 2"),
  channelStartDate = c("2022-01-01", "2022-02-01"),
  numberSubscribers = c(100, 150),
  numberViews = c(1000, 1500),
  totalVideos = c(50, 75),
  playlistId = c("playlist1", "playlist2"),
  country = c("US", "CA"),
  thumbnails_present = c("Yes", "No"),
  engagement_ratio = c(10, 12)
)

test_that("display_channel_info works with a valid data frame", {
  # Check if the result is a character string
  expect_error(display_channel_info(mock_channel_stats),
               "Error: The number of rows in your data frame is greater than 1. This method support up to 1 channel.")
})

mock_channel_stats1 <- data.frame(
  channelID = c("channel1"),
  channelName = c("Channel 1"),
  channelStartDate = c("2022-01-01"),
  numberSubscribers = c(100),
  numberViews = c(1000),
  totalVideos = c(50),
  playlistId = c("playlist1"),
  country = c("US"),
  thumbnails_present = c("Yes"),
  engagement_ratio = c(10)
)

test_that("display_channel_info works with a valid data frame", {
  # Call the function with the mock data
  result <- display_channel_info(mock_channel_stats1)

  # Check if the expected column names are present in the result
  expect_true(grepl("Channel ID", result))
  expect_true(grepl("Name", result))
  expect_true(grepl("Start day", result))
  expect_true(any(grepl("Number of subscribers", result)))
  expect_true(any(grepl("Number of views", result)))
  expect_true(grepl("Total videos", result))
  expect_true(grepl("Country", result))
  expect_true(grepl("Thumbnails", result))
  expect_true(grepl("Engagement ratio", result))
})

################################################################################
# channel comparator plots

# Mock data for testing
mock_channel_stats3 <- data.frame(
  channelName = c("Channel1", "Channel2"),
  numberSubscribers = c(1000, 1500)
)

test_that("create_bar_subscribers_plot works with a valid data frame", {
  # Call the function with the mock data
  plot_result <- create_bar_subscribers_plot(mock_channel_stats3)

  # Check if the channel_stats argument is a data frame
  expect_s3_class(mock_channel_stats3, "data.frame")

  # Check if the result is a ggplot object
  expect_s3_class(plot_result, "gg")
})


test_that("create_bar_views_plot works with a valid data frame", {
  # Call the function with the mock data
  plot_result <- create_bar_views_plot(mock_channel_stats)

  # Check if the channel_stats argument is a data frame
  expect_s3_class(mock_channel_stats, "data.frame")

  # Check if the result is a ggplot object
  expect_s3_class(plot_result, "gg")
})


test_that("create_bar_videos_plot works with a valid data frame", {
  # Call the function with the mock data
  plot_result <- create_bar_videos_plot(mock_channel_stats)

  # Check if the channel_stats argument is a data frame
  expect_s3_class(mock_channel_stats, "data.frame")

  # Check if the result is a ggplot object
  expect_s3_class(plot_result, "gg")
})


test_that("create_engagement_plot works with a valid data frame", {
  # Call the function with the mock data
  plot_result <- create_engagement_plot(mock_channel_stats)

  # Check if the channel_stats argument is a data frame
  expect_s3_class(mock_channel_stats, "data.frame")

  # Check if the result is a ggplot object
  expect_s3_class(plot_result, "gg")
})

test_that("create_growth_plot works with a valid data frame", {
  # Call the function with the mock data
  plot_result <- create_growth_plot(mock_channel_stats)

  # Check if the channel_stats argument is a data frame
  expect_s3_class(mock_channel_stats, "data.frame")

  # Check if the result is a ggplot object
  #expect_s3_class(plot_result, c("gg", "ggplot"))
})


test_that("create_growth_plot handles fewer than 5 rows", {
  # Check if the result is NULL
  expect_type(create_growth_plot(mock_channel_stats), "NULL")
})


>>>>>>> Stashed changes
