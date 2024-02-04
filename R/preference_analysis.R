library(dplyr)
library(ggplot2)

#' Helps to prepare data for preference breakdown
#'
#'This method gets the data from Get_Video_Detail method in video_details_util.R
#'Then groups the data by category and channelID
#'Then calculates count and sum of duration for each category and channel
#'Then calculates the percentage of time spent in each category
#'After preparing the above data,
#'calls Get_Video_Category method in video_category_util.R to get category details
#'Now merges the title from category details to the data frame in which we calculated
#' @param video_ids
#'
#' @return merged_info(data frame)
#' @import dplyr
#' @export
#' @examples preprare_data("ZTt9gsGcdDo,Qf06XDYXCXI")
#' @include video_details_util.R
#' @include video_category_util.R
#' @include get_channel_stats.R
preprare_data<-function(video_ids)
{
  videos <- Get_Video_Detail(video_ids,"AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")
  category_info <- videos %>%
    group_by(categoryid, channelId) %>%
    summarise(count = n(), duration_sum = sum(duration))

  total_duration = sum(category_info$duration_sum)
  category_info <- category_info %>%
    mutate(percentage_duration = (duration_sum / total_duration) * 100)

  category_ids <- category_info$categoryid
  category_ids <- paste(category_ids, collapse = ",")
  category_details <- Get_Video_Category(category_ids,"AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")
  merged_info <- merge(category_info, category_details, by.x = "categoryid", by.y = "categoryId")
  merged_info$channelID <- merged_info$channelId.x
  channel_ids<- paste(merged_info$channelId.x, collapse = ",")
  channel_info <- get_channel_stats("AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c",channel_ids)
  merged_info <- merge(merged_info, channel_info, by.x = "channelID", by.y = "channelID")
  merged_info
}

#' Helps to calculate statistics and display summary
#'
#' This method helps to calculate:
#' 1. minimum watch count
#' 2. category or categories with minimum watch count
#' 3. sum of duration in minutes of categories with the minimum watch count
#' 4. total percentage of time spent on categories with the minimum watch count
#' 5. maximum watch count
#' 6. category or categories with maximum watch count
#' 7. sum of duration in minutes of categories with the maximum watch count
#' 8. total percentage of time spent on categories with the maximum watch count
#' @param merged_info
#'
#' @export
#' df <- data.frame(categoryid = c("22", "27"),
#'       channelId = c("UCAuUUnT6oDeKwE6v1NGQxug", "UCtYLUTtgS3k1Fg4y5tAhLbw"),
#'       categoryTitle = c("Entertainment","Education"),
#'       count = c(1, 19),
#'       duration_sum = c(21.05, 399.95),
#'       percentage_duration = c(5, 95))
#' calculate_and_display_summary(df)
#'
#' @examples
calculate_and_display_summary<-function(merged_info)
{
  min_category <- min(merged_info$count)
  max_category <- max(merged_info$count)
  min_categorylist <- merged_info$categoryTitle[merged_info$count == min_category]
  max_categorylist <- merged_info$categoryTitle[merged_info$count == max_category]
  min_category_duration <- sum(merged_info$duration_sum[merged_info$count == min_category])
  max_category_duration <- sum(merged_info$duration_sum[merged_info$count == max_category])
  min_category_percentage <- sum(merged_info$percentage_duration[merged_info$count == min_category])
  max_category_percentage <- sum(merged_info$percentage_duration[merged_info$count == max_category])

  print("LEASE FAVOURTIE CATEGORY:")
  if(length(min_categorylist) == 1) {
    print(paste("Your least favourite category is ",min_categorylist[1]))
  }
  else if(length(min_categorylist) > 1){
    print(paste("Your least favourite categories are ",paste(min_categorylist, collapse = ", ")))
  }
  print(paste0("Total time spend in least favourite category: ", min_category_duration," min"))
  print(paste0("Total percentage of time spend in least favourite category: ", min_category_percentage,"%"))

  print(" ",quote=FALSE)
  print("MOST FAVOURTIE CATEGORY: ")
  if(length(max_categorylist) == 1) {
    print(paste("Your most favourite category is ",max_categorylist[1]))
  }
  else if(length(max_categorylist) > 1){
    print(paste("Your most favourite categories are ",paste(max_categorylist, collapse = ", ")))
  }
  print(paste0("Total time spend in most favourite category: ", max_category_duration," min"))
  print(paste0("Total percentage of time spend in most favourite category: ", max_category_percentage,"%"))

  print(" ",quote=FALSE)
  print("OVERALL CATEGORY: ")
  print(setNames(merged_info[, c("categoryTitle", "count", "duration_sum", "percentage_duration")],
                 c("Category", "Count", "Duration in mins", "Percecntage")))
}

#' Helps to display category in pi chart
#'@description
#'This method helps to create pi chart
#'with each slice representing the count of each category
#'
#' @param merged_info
#' @import ggplot2
#' @export
#' @examples
#' merged_data <- data.frame(categoryid = c("22", "27"),
#'       channelId = c("UCAuUUnT6oDeKwE6v1NGQxug", "UCtYLUTtgS3k1Fg4y5tAhLbw"),
#'       categoryTitle = c("Entertainment","Education"),
#'       count = c(1, 19),
#'       duration_sum = c(21.05, 399.95),
#'       percentage_duration = c(5, 95))
#' visualize(merged_data)
visualize<-function(merged_info)
{
  category_plot <- ggplot(merged_info, aes(x = " ", y = count, fill = categoryTitle)) +
    geom_bar(stat = "identity") +
    coord_polar("y", start = 0) +
    labs(title = "Breakdown on your watch category", fill = "categoryTitle") +
    theme_minimal()
  print(category_plot)
}

#' Helps to display category in pi chart
#'@description
#'This method helps to create pi chart
#'with each slice representing the count of each category
#'
#' @param merged_info
#' @import ggplot2
#' @export
#' @examples
#' merged_data <- data.frame(categoryid = c("22", "27"),
#'       channelId = c("UCAuUUnT6oDeKwE6v1NGQxug", "UCtYLUTtgS3k1Fg4y5tAhLbw"),
#'       channelName = c("TED", "Cookd"),
#'       categoryTitle = c("Entertainment","Education"),
#'       count = c(1, 19),
#'       duration_sum = c(21.05, 399.95),
#'       percentage_duration = c(5, 95))
#' visualize(merged_data)
visualize_channel<-function(merged_info)
{
  ggplot(merged_info, aes(x = channelName, y = 1, size = duration_sum, color = channelName)) +
    geom_point(alpha = 0.7,show.legend = FALSE) +
    scale_size_continuous(range = c(20, 70)) +
    labs(x = "Channel Name", y = NULL, size = "Duration", title="Visualizing Watch time per channel")+
    theme_minimal()
}

#' Main function that helps to co-ordinate all the functions
#'
#'This method calls prepare_data method to get data frame
#'Then calls calculate_and_display_summary to calculate statistics and print summary
#'Then calls visualize to visualize data
#' @param video_ids
#'
#' @return
#' @export
#' @import dplyr
#' @import ggplot2
#' @examples get_Preference_Breakdowm("Ks-_Mh1QhMc,Qf06XDYXCXI")
get_Preference_Breakdowm<-function(video_ids)
{
  tryCatch({
    if(missing(video_ids)){
      stop("video_ids parameter is required but its missing")
    }
    num_commas <- str_count(video_ids,",")
    print(num_commas)
    if(num_commas<9){
      stop("video_ids parameter should atleast contain 20 parameter")
    }
    video_ids <- gsub(" ", "", video_ids)
    merged_info <- preprare_data(video_ids)
    calculate_and_display_summary(merged_info)
    visualize(merged_info)
  },error = function(e){
    message("An error occurred: ", e$message)
    return(NULL)
  }
  )
}
