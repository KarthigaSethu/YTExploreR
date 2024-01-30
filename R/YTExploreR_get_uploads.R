library(httr)
library(dplyr)
library(jsonlite)

#' Date Formatter
#'
#' @param month: two digit numeric value from 1-12, to indicate month. 01 for Jan, 02 for Feb,  etc.
#' @param year: four digit numeric value, to indicate year.
#'
#' @return Two formatted strings, one month apart:
#'        Suitable to be plugged into the YouTube Activities API publishedBefore and publishedAfter parameters
#'
#' @examples format_date(5,2013) --> "2013-5-01T00:00:00Z", "2013-6-01T00:00:00Z"
#'

format_date <- function(month, year) {
  start_date <- paste0(year, "-", month, "-01T00:00:00Z")
  end_date <- ifelse(month == 12, paste0(year+1, "-01T00:00:00Z"), paste0(year, "-", month + 1, "-01T00:00:00Z"))
  return(list(start_date, end_date))

}


#' Monthly Upload Activity
#'
#' Input a YouTube channel id and retrieves activities that are carried out by that channel.
#' This includes: uploading videos, creating playlists (of pre-existing videos), likes activity, social activity and more.
#'
#'
#' @param chan_id: Unique identifier string associated with a single YouTube channel.
#'
#' @return sorted dataframe with columns associated with channel activity
#'
#' @examples get_uploads('UCyPYQTT20IgzVw92LDvtClw') --> result_df_uploads


format_date <- function(month, year) {
  start_date <- paste0(year, "-", month, "-01T00:00:00Z")
  end_date <- ifelse(month == 12, paste0(year + 1, "-01-01T00:00:00Z"), paste0(year, "-", month + 1, "-01T00:00:00Z"))
  return(list(start_date = start_date, end_date = end_date))
}

get_monthly_uploads <- function(chan_id, year) {

  api_key <- Sys.getenv("YOUTUBE_API")

  uploads_df <- data.frame()

  for (month in 1:12) {

    date_range <- format_date(month, year)

    params <- list(
      part = "snippet,contentDetails",
      channelId = chan_id,
      maxResults = 50,
      key = api_key,
      publishedBefore = date_range$end_date,
      publishedAfter = date_range$start_date
    )

    url <- 'https://youtube.googleapis.com/youtube/v3/activities?'

    r <- GET(url, query = params)

    if (status_code(r) != 200) {
      warning('Request for month ', month, ' was not successful!')
      next
    }

    response_data <- fromJSON(content(r, "text"))

    # Extract data from the response
    publishedAt <- response_data$items$snippet$publishedAt
    title <- response_data$items$snippet$title
    type <- response_data$items$snippet$type
    videoId <- response_data$items$contentDetails$upload$videoId

    uploads_df <- bind_rows(uploads_df, data.frame(publishedAt, title, type, videoId))
  }

  # Filter for only 'upload' type
  result_df_uploads <- uploads_df %>%
    filter(type == 'upload')

  return(result_df_uploads)
}


get_monthly_uploads('UCyPYQTT20IgzVw92LDvtClw', 2022)





