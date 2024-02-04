#' Table with channel information
#'
#' Display the general information about a channel id.
#'
#' @param channel_stats
#'
#' @return A table in the viewer.
#' @export
#'
#' @examples
#' # Providing a valid API Key and channel ids
#' api_key <- "AIzaSyB6df_K1PJy64w5VLZGYWyXSPYJ-TOoXVw"
#' # Specifying a unique channel id
#' channel_id = c('UC2UXDak6o7rBm23k3Vv5dww') # Tina Huang
#' # Call function to retrieve channel statistics data frame
#' channel_stats <- get_channel_stats(api_key, channel_id)
#' # Call the function to display the table with the channel statistics
#' display_channel_info(channel_stats)
display_channel_info <- function(channel_stats){

  # Load libraries
  library(knitr)
  library(kableExtra)

  channel_stats$engagement_ratio <- round(channel_stats$engagement_ratio, 0)
  channel_stats$numberSubscribers <- channel_stats$numberSubscribers / 1000
  channel_stats$numberViews <- channel_stats$numberViews / 1000

  colnames(channel_stats) <- c('Channel ID',
                               'Name',
                               'Start day',
                               'Number of subscribers (in thousands)',
                               'Number of views (in thousands)',
                               'Total videos',
                               'Playlist ID',
                               'Country',
                               'Thumbnails',
                               'Engagement ratio')

  # Create a Markdown-formatted table with a title
  table_channel_stats <-  kbl(t(channel_stats[,-7]), caption = "Channel information:") %>%
                          kable_classic(full_width = F, html_font = "Cambria")

  return(table_channel_stats)
}