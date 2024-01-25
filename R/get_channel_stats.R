#' Channel statistics
#'
#' @param api_key Is the alphanumeric key to get access to the YouTube API.
#' @param channel_ids A list of the channel identifiers that will be used for retrieve statistics. 
#'
#' @return A data frame with the statistics of the channels (channel name, number of subscribers, number of views, 
#' total videos, playlist ID and country)
#' @export
#'
#' @examples
#' # Set your API key
#' api_key <- "REPLACE_WITH_A_VALID_KEY"
#' # Define channel IDs
#' channel_ids <- c("UCtYLUTtgS3k1Fg4y5tAhLbw",  # Statquest
#'                 "UCLLw7jmFsvfIVaUFsLs8mlQ")  # Luke Barousse
#' # Call the function to get channel statistics
#' channel_stats <- get_channel_stats(api_key, channel_ids)
#' # Print the resulting data frame
#' print(channel_stats)
get_channel_stats <- function(api_key, channel_ids) {
  all_data <- data.frame()
  
  for (channel_id in channel_ids) {
    url <- paste0("https://www.googleapis.com/youtube/v3/channels",
                  "?part=snippet,statistics,contentDetails",
                  "&id=", channel_id,
                  "&key=", api_key)
    
    response <- GET(url)
    channel_stats <- fromJSON(content(response, "text"))
    
    data <- data.frame(
      channelName = channel_stats$items$snippet$title,
      numberSubscribers = channel_stats$items$statistics$subscriberCount,
      numberViews = channel_stats$items$statistics$viewCount,
      totalVideos = channel_stats$items$statistics$videoCount,
      playlistId = channel_stats$items$contentDetails$relatedPlaylists$uploads,
      country = channel_stats$items$snippet$country
    )
    
    all_data <- rbind(all_data, data)
  }
  
  return(all_data)
}