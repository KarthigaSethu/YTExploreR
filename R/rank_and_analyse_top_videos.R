library(ggplot2)


#' @param channelId
#'
#' @param year
#' @export
#'
#' @include YTExploreR_get_uploads.R
get_video_ids <-function(channelId,year)
{
  data <-get_monthly_uploads(channelId, year)
  video_ids <- data$videoId
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
#' @param year
#'
#' @return videos a dataframe
#' @export
#'
#' @include video_details_util.R
#' @examples get_video_and_rank("UCtYLUTtgS3k1Fg4y5tAhLbw",2023)
get_video_and_rank<-function(channelID, year)
{
  tryCatch({
    video_ids = get_video_ids(channelID, year)
    num_commas <- str_count(video_ids,",")
    print(num_commas)
    if(num_commas<19){
      stop("The channel contains only less than 20 videos")
    }
    videos <- Get_Video_Detail(video_ids,"AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")
    videos$points <- ((0.3 * videos$views) + (0.2 * videos$likes) + (0.2 * videos$comments))
    videos <- videos[order(videos$points), ]
    videos
  },error = function(e){
    message("An error occurred: ", e$message)
    return(NULL)
  }
  )
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
  filtered_video_details <- select(filtered_video_details, videotitle, points)
  top_videos <-setNames(filtered_video_details, c("Title","YTExplorer Rank"))
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
#' @examples get_top10_videos("UCtYLUTtgS3k1Fg4y5tAhLbw",2023)
get_top10_videos<-function(channelId,year){
  tryCatch({
    if(missing(channelId) | missing(year)){
      stop("channelId and year parameters are required but its missing")
    }
    videos <- get_video_and_rank(channelId,year)
    filtered_videos <- top_videos<- tail(videos,10)
    proportion_data<-calculate_proportion(filtered_videos, videos)
    print_videos(filtered_videos)
    visualize_proportion(proportion_data)
  },error =function(e){
    message("An error occurred: ", e$message)
    return(NULL)
  }
  )
}
