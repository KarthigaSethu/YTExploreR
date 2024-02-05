#' Channel statistics
#'
#' This function retrieves statistics for one or more YouTube channels using the YouTube API.
#'
#' @param api_key An alphanumeric key to access the YouTube API.
#' @param channel_ids A character vector of channel identifiers used for retrieve statistics.
#'
#' @return A data frame with the statistics, including:
#' - channelID: Unique identifier from the channel.
#' - channelName: The channel's title.
#' - numberSubscribers: The number of subscribers that the channel has.
#' - numberViews: The number of times the channel has been viewed.
#' - totalVideos: The number of public videos uploaded to the channel.
#' - playlistId: The ID of the playlist that contains the channel's liked videos.
#' - channelStartDate: The date and time that the channel was created.
#' - country: The country with which the channel is associated.
#' - thumbnails_present: Indicates whether thumbnails are present (Yes/No)
#' - engagement_ratio: The ratio of subscribers to views (in percentage)
#'
#' @export
#'
#' @examples
#' # Set your API key
#' api_key <- "AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw"
#' # Define channel IDs
#' channel_ids <- c("UCtYLUTtgS3k1Fg4y5tAhLbw",  # Statquest
#'                 "UCLLw7jmFsvfIVaUFsLs8mlQ")  # Luke Barousse
#' # Call the function to get channel statistics
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' # Print the resulting data frame
#' print(channel_stats)
get_channel_stats <- function(api_key, channel_ids) {
  # Load the required libraries
  library(httr)
  library(jsonlite)
  library(anytime)

  # Check if channel_ids is a vector of strings
  if (!is.character(channel_ids) || length(channel_ids) == 0 || any(!nzchar(channel_ids))) {
    stop("Error: The channel ids must be a non-empty vector of strings")
  }

  all_data <- data.frame()

  for (channel_id in channel_ids) {
    url <- paste0("https://www.googleapis.com/youtube/v3/channels",
                  "?part=snippet,statistics,contentDetails",
                  "&id=", channel_id,
                  "&key=", api_key)

    response <- GET(url)
    channel_stats <- fromJSON(content(response, "text"))

    # Extract the start date from channel_stats
    channelStartDate <- channel_stats$items$snippet$publishedAt

    data <- data.frame(
      channelID = channel_stats$items$id,
      channelName = channel_stats$items$snippet$title,
      channelStartDate = channel_stats$items$snippet$publishedAt,
      numberSubscribers = as.integer(channel_stats$items$statistics$subscriberCount),
      numberViews = as.integer(channel_stats$items$statistics$viewCount),
      totalVideos = as.integer(channel_stats$items$statistics$videoCount),
      playlistId = channel_stats$items$contentDetails$relatedPlaylists$uploads,
      country = channel_stats$items$snippet$country
    )

    # Use tryCatch to handle errors during date parsing
    tryCatch({
      data$channelStartDate <- anytime::anytime(channelStartDate)
    }, error = function(e) {
      stop("Error: Unable to parse channel start date.")
    })

    # Use anytime package to parse dates in various formats
    data$channelStartDate <- anytime::anytime(channelStartDate)
    # Format as yyyy-mm-dd
    data$channelStartDate <- format(data$channelStartDate, "%Y-%m-%d")

    # Check if "thumbnails" field is present and create a new column
    data$thumbnails_present <- ifelse(!is.null(channel_stats$items$snippet$thumbnails), "Yes", "No")

    all_data <- rbind(all_data, data)
  }

  # Adds a column with the engagement ratio
  all_data$engagement_ratio <- (all_data$numberSubscribers / all_data$numberViews)*100

  return(all_data)
}
