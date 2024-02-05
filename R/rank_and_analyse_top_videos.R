library(ggplot2)

# dummy function
# NOTE : This has to be replaced once Activity API is ready
get_video_ids <-function()
{
  video_ids <- c("Ks-_Mh1QhMc","ZTt9gsGcdDo", "Qf06XDYXCXI", "Qf06XDYXCXI", "rC9vw2dSpQo", "rC9vw2dSpQo", "Ka04Dj7DxGk", "bQ5BoolX9Ag", "bQ5BoolX9Ag", "L8HKweZIOmg", "PSs6nxngL6k", "zxQyTK8quyY", "zxQyTK8quyY", "8ZcccMzTz7Y", "8ZcccMzTz7Y", "YaQEUgIr4Mk", "YaQEUgIr4Mk", "PSs6nxngL6k", "PSs6nxngL6k", "02zO75hHpZQ")
  video_ids_string <- paste(video_ids, collapse = ",")
  return(video_ids_string)
}


#' Helps to rank the videos
#'
#' This method:
#' gets video details from Get_Video_Detail method in video_details_util.R
#' then calculates ranks with a formula `(0.3*views) + (0.2 * likes) + (0.2 * comments)`
#' This formula is used because instead of giving equal weight age for views, likes and comments,
#' we want to emphasize on it's importance
#'
#' @param channelID
#'
#' @return videos a dataframe
#' @export
#'
#' @include video_details_util.R
#' @examples get_video_and_rank("UCtYLUTtgS3k1Fg4y5tAhLbw")
get_video_and_rank<-function(channelID)
{
  # Get from Activity but as of now get from dummy method
  video_ids = get_video_ids()
  videos <- Get_Video_Detail(video_ids,"AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")
  videos$points <- ((0.3 * videos$views) + (0.2 * videos$likes) + (0.2 * videos$comments))
  videos <- videos[order(videos$points), ]
  videos
}

#' Helps to print top 10 videos
#'
#' This method helps to rename the videos and helps to print it
#'
#' @param filtered_video_details
#' @param reverse
#'
#' @export
#'
#' @examples
#' dummy_data <- data.frame(
#' videotitle = "Dummy Video",
#' duration = 10,
#' views = 1000,
#' likes = 500,
#' comments = 100,
#' points = 0
#' )
#' print_videos(dummy_data)
print_videos<-function(filtered_video_details, reverse = TRUE)
{
  top_videos <- setNames(filtered_video_details[, c("videotitle", "duration", "views", "likes","comments", "points")],
                         c("Title", "Duration", "Total Views", "Total Likes","Total Comments","YTExplorers Rank"))
  if(reverse){
    top_videos<-top_videos[nrow(top_videos):1, ]
  }
  print(top_videos)
}

#' Helps to calculate proportion of views, count,comments, duration
#'
#' @param filtered_video_details
#' @param full_video_detail
#'
#' @return proportion_data
#' @export
#'
#' @examples
#' dummy_data <- data.frame(
#' videotitle = "Dummy Video",
#' duration = 10,
#' views = 1000,
#' likes = 500,
#' comments = 100,
#' points = 0
#' )
#' calculate_proportion(dummy_data, dummy_data)
calculate_proportion<-function(filtered_video_details, full_video_detail)
{
  top_view_count  <- sum(filtered_video_details$views)
  top_like_count  <- sum(filtered_video_details$likes)
  top_comment_count  <- sum(filtered_video_details$comments)
  top_duration <- sum(filtered_video_details$duration)

  total_view_count  <- sum(full_video_detail$views)
  total_like_count  <- sum(full_video_detail$likes)
  total_comment_count  <- sum(full_video_detail$comments)
  total_duration <- sum(full_video_detail$duration)

  total = nrow(full_video_detail)
  views_proportion <- (top_view_count / total_view_count) * 100
  likes_proportion <- (top_like_count / total_like_count) * 100
  comment_proportion <- (top_comment_count/ total_comment_count)*100
  duration_proportion <- (top_duration/total_duration)*10

  proportion_data <- data.frame(
    Category = c("Views", "Likes", "Comments", "Duration"),
    Proportion = c(views_proportion, likes_proportion, comment_proportion, duration_proportion)
  )

  proportion_data
}

#' Helps to visualize the proportion
#'
#' @param proportion_data
#'
#' @export
#' @import ggplot2
#' @examples
#' dummy_data <- data.frame(
#' Category = c("Views", "Likes", "Comments", "Duration"),
#' Proportion = c(0.25, 0.35, 0.20, 0.30) # Example proportions (you can change these values as needed)
#' )
#' visualize_proportion(dummy_data)
visualize_proportion<-function(proportion_data)
{
  ggplot(proportion_data, aes(x = Category, y = Proportion,fill = Category)) +
    geom_bar(stat = 'identity',  width = 0.5) +
    labs(x = "", y = "Proportion (%)", title = "Proportions of Top 10 Videos") +
    theme_minimal()

}

#' Helps to co-ordinate all the function
#'  Ranks and order the video details by calling get_video_and_rank
#'  Then filters top 10 videos
#'  Then helps to calculate proportion by calling calculate_proportion
#'  Then prints and visualizes data
#' @param channelId
#'
#' @export
#'
#' @examples get_top10_videos("UCtYLUTtgS3k1Fg4y5tAhLbw")
get_top10_videos<-function(channelId)
{
  videos <- get_video_and_rank(channelId)
  filtered_videos <- top_videos<- tail(videos,10)
  proportion_data<-calculate_proportion(filtered_videos, videos)
  print_videos(filtered_videos)
  visualize_proportion(proportion_data)
}




