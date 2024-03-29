library(httr)
library(jsonlite)
library(stringr)

#' Helps to Extract Time in minutes
#' The YouTube time period follows ISO 8601 time that looks like PT1H45M35S
#' This method helps to extract time from above mentioned format to minutes
#' For instance:
#' PT1H30M30S is converted to 90.5 minutes using regex
#'
#' @import stringr
#' @param input  time in ISO 8601 format
#' @return time in minutes
#' @export
#' @examples
#' Extract_Time_in_mins("PT1H30M30S")
#' Extract_Time_in_mins("PT30M30S")
#' Extract_Time_in_mins("PT1H30S")
Extract_Time_in_mins<-function(input)
{
  pattern<-"((\\d+)H)?((\\d+)M)?((\\d+)S)?"
  matches <- stringr::str_match_all(input, pattern)
  h <- matches[[1]][3, 3]
  m <- matches[[1]][3, 5]
  s <- matches[[1]][3, 7]
  if(is.na(h)){h<-0}
  if(is.na(m)){m<-0}
  if(is.na(s)){s<-0}
  return ((as.numeric(h)*60)+as.numeric(m)+(as.numeric(s)/60))
}

#' Helps to get video details
#' All the essential details about a video or videos can be extracted from this method
#' This method supports single and multiple videos.
#' This method gives details such as:
#' 1. channelId
#' 2. videoID
#' 3. video Title
#' 4. published At
#' 5. publishedmonth
#' 6. categoryid
#' 7. duration
#' 8. definition
#' 9. views
#' 10.likes
#' 11.favourites
#' 12.comments
#' 13.publishedyear
#' and converts data into appropriate type
#'
#' @param video_id id of a video or comma seperated ids of a video
#' @param api_key api key to authenticate API
#'
#' @return data frame with details about the video
#' @export
#' @import httr
#' @import jsonlite
#' @examples
#' Get_Video_Detail("Ks-_Mh1QhMc", "AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")
#' Get_Video_Detail("Ks-_Mh1QhMc,Ks-_Mh1QhMc", "AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c")
Get_Video_Detail <- function(video_id, api_key)
{
  url <- paste0("https://youtube.googleapis.com/youtube/v3/videos",
                "?part=snippet%2CcontentDetails%2Cstatistics",
                "&id=",video_id,
                "&key=", api_key)
  headers <- c(
    "Authorization" = "Bearer AIzaSyBqrBJzAuitb-PpfyPrV7ABbLn8_nIbK3c",
    "Accept" = "application/json"
  )
  response <- httr::GET(url, headers = headers)
  video_detail <- jsonlite::fromJSON(httr::content(response, "text"))

  channelId = video_detail$items$snippet$channelId
  channelName = video_detail$items$snippet$channelTitle
  videoID = video_detail$items$id
  videotitle = video_detail$items$snippet$title
  publishedAt = video_detail$items$snippet$publishedAt
  categoryid = video_detail$items$snippet$categoryId
  duration = video_detail$items$contentDetails$duration
  duration =unlist(lapply(duration, Extract_Time_in_mins))
  definition = video_detail$items$contentDetails$definition
  views =  video_detail$items$statistics$viewCount
  likes = video_detail$items$statistics$likeCount
  favourites = video_detail$items$statistics$favoriteCount
  comments = video_detail$items$statistics$commentCount

  publishedAt = as.POSIXlt(publishedAt, format = "%Y-%m-%dT%H:%M:%SZ")
  publishedmonth <- format(publishedAt, "%B")
  publishedyear <- format(publishedAt, "%Y")

  data <- data.frame(
    channelId = channelId,
    videoID = videoID,
    videotitle = videotitle,
    publishedAt = publishedAt,
    publishedmonth = publishedmonth,
    publishedyear = publishedyear,
    categoryid = categoryid,
    duration = duration,
    definition = definition,
    views = as.numeric(views),
    likes = as.numeric(likes),
    favourites = as.numeric(favourites),
    comments = as.numeric(comments)
  )
  return(data)
}
