library(httr)
library(dplyr)
library(jsonlite)

#' get_upload_activity
#' Input a YouTube channel id and retrieves activities that are carried out by that channel.
#' This includes: uploading videos, creating playlists (of pre-existing videos), likes activity, social activity and more.
#'
#'
#' @param chan_id: Unique identifier string associated with a single YouTube channel.
#'
#' @return sorted dataframe with columns associated with channel activity
#'
#' @examples get_uploads('UCyPYQTT20IgzVw92LDvtClw')

get_uploads <- function(chan_id) {

  api_key <- Sys.getenv("YOUTUBE_API")

  params <- list(
    part = "snippet,contentDetails",
    channelId = chan_id,
    maxResults = 50,
    key = api_key
  )

  url <- 'https://youtube.googleapis.com/youtube/v3/activities?'
  r1 <- GET(url, query = params)

  if (status_code(r1) != 200) {
    stop('Request was not successful!')
  }

  # response_data <- content(r1, "parsed")
  response_data <- fromJSON(content(r1, "text"))
  print(response_data$items[1])


  publishedAt <- response_data$items$snippet$publishedAt
  title <- response_data$items$snippet$title
  type <- response_data$items$snippet$type
  videoId <- response_data$items$contentDetails$upload$videoId

  uploads_df <- data.frame(publishedAt, title, type, videoId)

  return(uploads_df)
}

result_df <- get_uploads('UCsXVk37bltHxD1rDPwtNM8Q')
result_df
